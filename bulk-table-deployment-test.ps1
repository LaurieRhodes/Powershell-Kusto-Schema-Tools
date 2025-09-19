# ============================================================================
# Bulk Custom Table Deployment Script
# ============================================================================
# Deploys custom Log Analytics tables in bulk from Bicep templates generated
# by the json-to-bicep-table-export.ps1 script. This script recursively finds
# all Bicep files in the bicep-tables-from-json directory and deploys them
# using PowerShell variables instead of parameter files.
#
# This script is designed to test custom table deployments and validate
# the table schema generation logic from JSON exports.
# ============================================================================

# ============================================================================
# CONFIGURATION - UPDATE THESE VALUES FOR YOUR ENVIRONMENT
# ============================================================================

# Azure Configuration
$resourceGroupName = 'YOUR-RESOURCE-GROUP-NAME'
$workspaceName = 'YOUR-WORKSPACE-NAME'
$subscriptionId = 'YOUR-SUBSCRIPTION-ID'

# Table Configuration
$tablePlan = 'Analytics'      # Analytics or Basic
$retentionInDays = 30         # 4-730 days
$totalRetentionInDays = 30    # 4-4383 days

# Script Configuration
$bicepTablesDirectory = Join-Path $PSScriptRoot "bicep-tables-from-json"
$whatIfMode = $false          # Set to $true to validate templates without deploying
$testMode = $false            # Set to $true to only test a few tables first
$maxRetries = 1               # Number of retries for failed deployments
$retryDelaySeconds = 30       # Delay between retries
$cleanupAfterTest = $false    # Set to $true to delete tables after successful deployment

# Filtering options (leave empty to deploy all tables)
$includeOnly = @()            # Specify table names to deploy only specific tables
$excludeTables = @()          # Specify table names to exclude from deployment

# Error handling
$ErrorActionPreference = "Continue"  # Continue on errors to test all tables

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Write-LogMessage {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        "INFO" { "Cyan" }
        default { "White" }
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Get-TableNameFromBicepPath {
    param([string]$bicepFilePath)
    
    # Extract table name from file path - assuming structure like bicep-tables-from-json/TableName/tablename-table.bicep
    $parentDir = Split-Path (Split-Path $bicepFilePath -Parent) -Leaf
    if ($parentDir -eq "bicep-tables-from-json") {
        # File is directly in bicep-tables-from-json directory
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($bicepFilePath)
        return $fileName -replace '-table$', ''
    } else {
        # File is in a subdirectory - use directory name as table name
        return $parentDir
    }
}

function Get-ShortDeploymentName {
    param(
        [string]$tableName,
        [int]$attempt = 1
    )
    
    # Create a concise deployment name that stays under 64 characters
    # Pattern: tbl-{shortname}-{MMddHHmm}-a{attempt}
    $timestamp = Get-Date -Format "MMddHHmm"
    $prefix = "tbl-"
    $suffix = "-$timestamp-a$attempt"
    $maxTableLength = 64 - $prefix.Length - $suffix.Length
    
    # Truncate table name if necessary, keeping important parts
    if ($tableName.Length -gt $maxTableLength) {
        # For custom logs ending in _CL, prioritize keeping the _CL suffix
        if ($tableName.EndsWith("_CL")) {
            $maxBaseLength = $maxTableLength - 3  # Reserve 3 chars for _CL
            if ($maxBaseLength -gt 0) {
                $truncatedBase = $tableName.Substring(0, [Math]::Min($maxBaseLength, $tableName.Length - 3))
                $shortName = $truncatedBase + "_CL"
            } else {
                # If still too long, use hash
                $hash = ($tableName | ConvertTo-Json | Get-FileHash -Algorithm MD5).Hash.Substring(0, 8)
                $shortName = "CL_$hash"
            }
        } else {
            $shortName = $tableName.Substring(0, $maxTableLength)
        }
    } else {
        $shortName = $tableName
    }
    
    $deploymentName = "$prefix$shortName$suffix"
    
    # Final safety check
    if ($deploymentName.Length -gt 64) {
        # Use hash as last resort
        $hash = ($tableName | ConvertTo-Json | Get-FileHash -Algorithm MD5).Hash.Substring(0, 8)
        $deploymentName = "tbl-$hash-$timestamp-a$attempt"
    }
    
    return $deploymentName
}

function Test-TableExists {
    param(
        [string]$tableName,
        [string]$workspaceName,
        [string]$resourceGroupName
    )
    
    try {
        $table = Get-AzOperationalInsightsTable -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -TableName $tableName -ErrorAction SilentlyContinue
        return $table -ne $null
    } catch {
        return $false
    }
}

function Test-TableDeployment {
    param(
        [string]$bicepFilePath,
        [string]$tableName,
        [hashtable]$deploymentParams,
        [int]$attempt = 1
    )
    
    $deploymentName = Get-ShortDeploymentName -tableName $tableName -attempt $attempt
    
    # Validate deployment name length
    if ($deploymentName.Length -gt 64) {
        Write-LogMessage "Deployment name still too long: $($deploymentName.Length) chars - $deploymentName" "ERROR"
        return @{
            Success = $false
            Error = "Generated deployment name exceeds 64 characters: $deploymentName"
            DeploymentName = $deploymentName
            Attempt = $attempt
        }
    }
    
    try {
        Write-LogMessage "Attempting deployment $attempt for $tableName (deployment: $deploymentName)..." "INFO"
        
        if ($whatIfMode) {
            $result = Test-AzResourceGroupDeployment -ResourceGroupName $deploymentParams.ResourceGroupName -TemplateFile $bicepFilePath -workspaceName $deploymentParams.WorkspaceName -tablePlan $deploymentParams.TablePlan -retentionInDays $deploymentParams.RetentionInDays -totalRetentionInDays $deploymentParams.TotalRetentionInDays -ErrorAction Stop
            
            if ($result) {
                return @{
                    Success = $false
                    Error = "Template validation failed: $($result.Details | Out-String)"
                    DeploymentName = $deploymentName
                    Attempt = $attempt
                }
            } else {
                return @{
                    Success = $true
                    DeploymentName = $deploymentName
                    Attempt = $attempt
                    Message = "Template validation successful"
                }
            }
        } else {
            $deployment = New-AzResourceGroupDeployment -ResourceGroupName $deploymentParams.ResourceGroupName -Name $deploymentName -TemplateFile $bicepFilePath -workspaceName $deploymentParams.WorkspaceName -tablePlan $deploymentParams.TablePlan -retentionInDays $deploymentParams.RetentionInDays -totalRetentionInDays $deploymentParams.TotalRetentionInDays -ErrorAction Stop
            
            return @{
                Success = $true
                DeploymentName = $deploymentName
                Attempt = $attempt
                TableName = $deployment.Outputs.tableName.Value
                TableId = $deployment.Outputs.tableId.Value
                ProvisioningState = $deployment.Outputs.provisioningState.Value
            }
        }
    } catch {
        $errorMessage = $_.Exception.Message
        $errorDetails = ""
        
        # Extract more detailed error information
        if ($_.Exception.InnerException) {
            $errorDetails = $_.Exception.InnerException.Message
        }
        
        # Check for specific table-related errors
        $isSchemaError = $errorMessage -match "schema" -or $errorMessage -match "column"
        $isPermissionError = $errorMessage -match "permission" -or $errorMessage -match "authorization"
        $isResourceError = $errorMessage -match "resource.*not.*found" -or $errorMessage -match "does.*not.*exist"
        $isConflictError = $errorMessage -match "conflict" -or $errorMessage -match "already.*exists"
        $isPlanError = $errorMessage -match "plan" -or $errorMessage -match "retention"
        $isDeploymentNameError = $errorMessage -match "deploymentName.*exceeds.*maximum.*length" -or $errorMessage -match "exceeds.*maximum.*length.*64"
        
        return @{
            Success = $false
            Error = $errorMessage
            ErrorDetails = $errorDetails
            DeploymentName = $deploymentName
            Attempt = $attempt
            IsSchemaError = $isSchemaError
            IsPermissionError = $isPermissionError
            IsResourceError = $isResourceError
            IsConflictError = $isConflictError
            IsPlanError = $isPlanError
            IsDeploymentNameError = $isDeploymentNameError
        }
    }
}

function Remove-TestTable {
    param(
        [string]$tableName,
        [string]$workspaceName,
        [string]$resourceGroupName
    )
    
    try {
        Write-LogMessage "Cleaning up test table $tableName..." "INFO"
        Remove-AzOperationalInsightsTable -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -TableName $tableName -Force -Confirm:$false
        Write-LogMessage "Successfully removed test table $tableName" "SUCCESS"
    } catch {
        Write-LogMessage "Failed to remove test table $tableName : $($_.Exception.Message)" "WARN"
    }
}

function Get-TableStatistics {
    param([array]$results)
    
    $customTables = $results | Where-Object { $_.TableName -match "_CL$" }
    $microsoftTables = $results | Where-Object { $_.TableName -notmatch "_CL$" }
    
    return @{
        Total = $results.Count
        Custom = $customTables.Count
        Microsoft = $microsoftTables.Count
        Successful = ($results | Where-Object { $_.Success }).Count
        Failed = ($results | Where-Object { -not $_.Success }).Count
        CustomSuccessful = ($customTables | Where-Object { $_.Success }).Count
        CustomFailed = ($customTables | Where-Object { -not $_.Success }).Count
        MicrosoftSuccessful = ($microsoftTables | Where-Object { $_.Success }).Count
        MicrosoftFailed = ($microsoftTables | Where-Object { -not $_.Success }).Count
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-LogMessage "Bulk Custom Table Deployment Script" "INFO"
Write-LogMessage "====================================" "INFO"

Write-LogMessage "Configuration:" "INFO"
Write-LogMessage "  Resource Group: $resourceGroupName" "INFO"
Write-LogMessage "  Workspace: $workspaceName" "INFO"
Write-LogMessage "  Table Plan: $tablePlan" "INFO"
Write-LogMessage "  Retention: $retentionInDays days" "INFO"
Write-LogMessage "  Total Retention: $totalRetentionInDays days" "INFO"
Write-LogMessage "  Bicep Directory: $bicepTablesDirectory" "INFO"
Write-LogMessage "  What-If Mode: $whatIfMode" "INFO"
Write-LogMessage "  Test Mode: $testMode" "INFO"
Write-LogMessage "  Cleanup After Test: $cleanupAfterTest" "INFO"

# Validate prerequisites
$requiredModules = @('Az.Resources', 'Az.OperationalInsights')
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-LogMessage "$module module not found. Install with: Install-Module $module" "ERROR"
        exit 1
    }
    
    if (-not (Get-Module $module)) {
        Import-Module $module
    }
}

# Check Azure context
$context = Get-AzContext
if (-not $context) {
    Write-LogMessage "Not logged into Azure. Please run Connect-AzAccount" "ERROR"
    exit 1
}

Write-LogMessage "Authenticated as: $($context.Account.Id)" "SUCCESS"

# Set subscription context
if ($context.Subscription.Id -ne $subscriptionId) {
    Set-AzContext -SubscriptionId $subscriptionId | Out-Null
    Write-LogMessage "Switched to subscription: $subscriptionId" "SUCCESS"
}

# Validate configuration
if ($resourceGroupName -eq 'YOUR-RESOURCE-GROUP-NAME') {
    Write-LogMessage "Please update the configuration section with your actual Azure resource details" "ERROR"
    exit 1
}

# Validate bicep tables directory
if (-not (Test-Path $bicepTablesDirectory)) {
    Write-LogMessage "Bicep tables directory not found: $bicepTablesDirectory" "ERROR"
    exit 1
}

# Validate workspace exists
try {
    $workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $workspaceName -ErrorAction Stop
    Write-LogMessage "Validated workspace: $workspaceName" "SUCCESS"
} catch {
    Write-LogMessage "Workspace not found: $workspaceName in resource group $resourceGroupName" "ERROR"
    exit 1
}

# Find all Bicep table files
Write-LogMessage "Discovering Bicep table files in $bicepTablesDirectory..." "INFO"
$bicepFiles = Get-ChildItem -Path $bicepTablesDirectory -Filter "*-table.bicep" -Recurse | Where-Object {
    $_.Name -match '.*-table\.bicep$'  # Only table files, not parameters
}

if ($bicepFiles.Count -eq 0) {
    Write-LogMessage "No table Bicep files found in $bicepTablesDirectory" "ERROR"
    exit 1
}

Write-LogMessage "Found $($bicepFiles.Count) table Bicep files" "SUCCESS"

# Filter files based on configuration
$filteredFiles = $bicepFiles
if ($includeOnly.Count -gt 0) {
    $filteredFiles = $bicepFiles | Where-Object {
        $tableName = Get-TableNameFromBicepPath $_.FullName
        $tableName -in $includeOnly
    }
    Write-LogMessage "Filtered to $($filteredFiles.Count) files based on include list" "INFO"
}

if ($excludeTables.Count -gt 0) {
    $filteredFiles = $filteredFiles | Where-Object {
        $tableName = Get-TableNameFromBicepPath $_.FullName
        $tableName -notin $excludeTables
    }
    Write-LogMessage "Filtered to $($filteredFiles.Count) files after exclusions" "INFO"
}

if ($testMode -and $filteredFiles.Count -gt 5) {
    $filteredFiles = $filteredFiles | Select-Object -First 5
    Write-LogMessage "Test mode: Limited to first 5 files" "INFO"
}

# Show preview of tables to be deployed (with deployment names)
Write-LogMessage "Tables to be deployed:" "INFO"
$filteredFiles | ForEach-Object {
    $tableName = Get-TableNameFromBicepPath $_.FullName
    $tableType = if ($tableName -match "_CL$") { "Custom" } else { "Microsoft" }
    $deploymentName = Get-ShortDeploymentName -tableName $tableName
    Write-LogMessage "  - $tableName ($tableType) -> $deploymentName ($($deploymentName.Length) chars)" "INFO"
}

# Prepare deployment parameters
$deploymentParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName = $workspaceName
    TablePlan = $tablePlan
    RetentionInDays = $retentionInDays
    TotalRetentionInDays = $totalRetentionInDays
}

# Track results
$results = @()
$successCount = 0
$failureCount = 0

Write-LogMessage "Starting table deployments..." "INFO"
Write-LogMessage "=============================" "INFO"

foreach ($bicepFile in $filteredFiles) {
    $tableName = Get-TableNameFromBicepPath $bicepFile.FullName
    $isCustomTable = $tableName -match "_CL$"
    $tableType = if ($isCustomTable) { "Custom" } else { "Microsoft" }
    
    Write-LogMessage "Processing table: $tableName ($tableType)" "INFO"
    
    # Check if table already exists
    if (-not $whatIfMode) {
        $tableExists = Test-TableExists -tableName $tableName -workspaceName $workspaceName -resourceGroupName $resourceGroupName
        if ($tableExists) {
            Write-LogMessage "Table $tableName already exists - skipping deployment" "WARN"
            
            $results += [PSCustomObject]@{
                TableName = $tableName
                TableType = $tableType
                Success = $false
                Error = "Table already exists"
                Skipped = $true
                BicepFile = $bicepFile.FullName
            }
            continue
        }
    }
    
    $deploymentResult = $null
    $finalAttempt = 1
    
    # Retry logic
    for ($attempt = 1; $attempt -le $maxRetries; $attempt++) {
        $deploymentResult = Test-TableDeployment -bicepFilePath $bicepFile.FullName -tableName $tableName -deploymentParams $deploymentParams -attempt $attempt
        $finalAttempt = $attempt
        
        if ($deploymentResult.Success) {
            break
        }
        
        if ($attempt -lt $maxRetries) {
            Write-LogMessage "Deployment failed, retrying in $retryDelaySeconds seconds..." "WARN"
            Start-Sleep -Seconds $retryDelaySeconds
        }
    }
    
    # Process results
    if ($deploymentResult.Success) {
        $successCount++
        Write-LogMessage "SUCCESS: $tableName ($tableType table)" "SUCCESS"
        
        # Clean up test table if cleanup is enabled and not in what-if mode
        if ($cleanupAfterTest -and -not $whatIfMode) {
            Start-Sleep -Seconds 5  # Give table time to provision
            Remove-TestTable -tableName $tableName -workspaceName $workspaceName -resourceGroupName $resourceGroupName
        }
    } else {
        $failureCount++
        Write-LogMessage "FAILED: $tableName ($tableType table) - $($deploymentResult.Error)" "ERROR"
        if ($deploymentResult.ErrorDetails) {
            Write-LogMessage "  Details: $($deploymentResult.ErrorDetails)" "ERROR"
        }
    }
    
    # Store detailed results
    $results += [PSCustomObject]@{
        TableName = $tableName
        TableType = $tableType
        Success = $deploymentResult.Success
        Error = $deploymentResult.Error
        ErrorDetails = $deploymentResult.ErrorDetails
        DeploymentName = $deploymentResult.DeploymentName
        Attempts = $finalAttempt
        IsSchemaError = $deploymentResult.IsSchemaError
        IsPermissionError = $deploymentResult.IsPermissionError
        IsResourceError = $deploymentResult.IsResourceError
        IsConflictError = $deploymentResult.IsConflictError
        IsPlanError = $deploymentResult.IsPlanError
        IsDeploymentNameError = $deploymentResult.IsDeploymentNameError
        BicepFile = $bicepFile.FullName
        Skipped = $false
    }
}

# ============================================================================
# SUMMARY REPORT
# ============================================================================

Write-LogMessage "" "INFO"
Write-LogMessage "BULK TABLE DEPLOYMENT SUMMARY" "INFO"
Write-LogMessage "==============================" "INFO"
Write-LogMessage "" "INFO"

$stats = Get-TableStatistics -results $results

Write-LogMessage "Overall Results:" "INFO"
Write-LogMessage "  Total Tables Processed: $($stats.Total)" "INFO"
Write-LogMessage "  Successful Deployments: $successCount" "SUCCESS"
Write-LogMessage "  Failed Deployments: $failureCount" "ERROR"
if ($stats.Total -gt 0) {
    Write-LogMessage "  Success Rate: $([math]::Round(($successCount / $stats.Total) * 100, 1))%" "INFO"
}
Write-LogMessage "" "INFO"

Write-LogMessage "Table Type Breakdown:" "INFO"
Write-LogMessage "  Custom Tables: $($stats.Custom) (Success: $($stats.CustomSuccessful), Failed: $($stats.CustomFailed))" "INFO"
Write-LogMessage "  Microsoft Tables: $($stats.Microsoft) (Success: $($stats.MicrosoftSuccessful), Failed: $($stats.MicrosoftFailed))" "INFO"
Write-LogMessage "" "INFO"

# Successful deployments
$successfulTables = $results | Where-Object { $_.Success }
if ($successfulTables.Count -gt 0) {
    Write-LogMessage "Successfully Deployed Tables:" "SUCCESS"
    $successfulTables | ForEach-Object {
        Write-LogMessage "  + $($_.TableName) ($($_.TableType))" "SUCCESS"
    }
    Write-LogMessage "" "INFO"
}

# Failed deployments by error type
$failedTables = $results | Where-Object { -not $_.Success -and -not $_.Skipped }
if ($failedTables.Count -gt 0) {
    Write-LogMessage "Failed Deployments:" "ERROR"
    
    # Group by error type
    $schemaErrors = $failedTables | Where-Object { $_.IsSchemaError }
    $permissionErrors = $failedTables | Where-Object { $_.IsPermissionError }
    $conflictErrors = $failedTables | Where-Object { $_.IsConflictError }
    $planErrors = $failedTables | Where-Object { $_.IsPlanError }
    $deploymentNameErrors = $failedTables | Where-Object { $_.IsDeploymentNameError }
    $otherErrors = $failedTables | Where-Object { -not ($_.IsSchemaError -or $_.IsPermissionError -or $_.IsConflictError -or $_.IsPlanError -or $_.IsDeploymentNameError) }
    
    if ($deploymentNameErrors.Count -gt 0) {
        Write-LogMessage "  Deployment Name Errors:" "ERROR"
        $deploymentNameErrors | ForEach-Object {
            Write-LogMessage "    - $($_.TableName): $($_.Error)" "ERROR"
        }
    }
    
    if ($schemaErrors.Count -gt 0) {
        Write-LogMessage "  Schema Errors:" "ERROR"
        $schemaErrors | ForEach-Object {
            Write-LogMessage "    - $($_.TableName): $($_.Error)" "ERROR"
        }
    }
    
    if ($permissionErrors.Count -gt 0) {
        Write-LogMessage "  Permission Errors:" "ERROR"
        $permissionErrors | ForEach-Object {
            Write-LogMessage "    - $($_.TableName): $($_.Error)" "ERROR"
        }
    }
    
    if ($conflictErrors.Count -gt 0) {
        Write-LogMessage "  Conflict Errors:" "ERROR"
        $conflictErrors | ForEach-Object {
            Write-LogMessage "    - $($_.TableName): $($_.Error)" "ERROR"
        }
    }
    
    if ($planErrors.Count -gt 0) {
        Write-LogMessage "  Plan/Retention Errors:" "ERROR"
        $planErrors | ForEach-Object {
            Write-LogMessage "    - $($_.TableName): $($_.Error)" "ERROR"
        }
    }
    
    if ($otherErrors.Count -gt 0) {
        Write-LogMessage "  Other Errors:" "ERROR"
        $otherErrors | ForEach-Object {
            Write-LogMessage "    - $($_.TableName): $($_.Error)" "ERROR"
        }
    }
    Write-LogMessage "" "INFO"
}

# Skipped tables
$skippedTables = $results | Where-Object { $_.Skipped }
if ($skippedTables.Count -gt 0) {
    Write-LogMessage "Skipped Tables (Already Exist):" "WARN"
    $skippedTables | ForEach-Object {
        Write-LogMessage "  ~ $($_.TableName)" "WARN"
    }
    Write-LogMessage "" "INFO"
}

# Recommendations
Write-LogMessage "Recommendations:" "INFO"
if ($stats.CustomSuccessful -gt 0) {
    Write-LogMessage "  Custom table generation from JSON appears to be working correctly" "SUCCESS"
}

if ($failedTables.Count -gt 0) {
    $schemaErrorCount = ($failedTables | Where-Object { $_.IsSchemaError }).Count
    if ($schemaErrorCount -gt 0) {
        Write-LogMessage "  Review schema errors - may indicate issues with JSON-to-Bicep conversion" "WARN"
    }
    
    $conflictErrorCount = ($failedTables | Where-Object { $_.IsConflictError }).Count
    if ($conflictErrorCount -gt 0) {
        Write-LogMessage "  Consider enabling table existence check to skip existing tables" "WARN"
    }
    
    $deploymentNameErrorCount = ($failedTables | Where-Object { $_.IsDeploymentNameError }).Count
    if ($deploymentNameErrorCount -gt 0) {
        Write-LogMessage "  Deployment name errors detected - algorithm needs further improvement" "WARN"
    }
}

Write-LogMessage "" "INFO"
Write-LogMessage "Detailed results available in results variable" "INFO"

if ($whatIfMode) {
    Write-LogMessage "Note: What-If mode was enabled - no actual deployments were made" "INFO"
} elseif ($cleanupAfterTest) {
    Write-LogMessage "Note: Cleanup was enabled - successfully deployed tables were removed" "INFO"
}

Write-LogMessage "" "INFO"
Write-LogMessage "Deployment test completed at $(Get-Date)" "INFO"

# Export results to CSV for further analysis
$csvPath = Join-Path $PSScriptRoot "table-deployment-results-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation
Write-LogMessage "Detailed results exported to: $csvPath" "INFO"