# ============================================================================
# Bulk DCR Deployment Test Script
# ============================================================================
# Tests the deployment of Data Collection Rules in bulk to validate which
# Microsoft tables are actually writable via DCR and to verify the
# output stream logic (Microsoft- vs Custom- prefixes)
#
# This script recursively finds all .bicep files in the DCR directory,
# attempts to deploy each one, and provides a comprehensive summary
# of successful vs failed deployments with error details.
# ============================================================================

# ============================================================================
# CONFIGURATION - UPDATE THESE VALUES FOR YOUR ENVIRONMENT
# ============================================================================

# Azure Configuration
$resourceGroupName = 'YOUR-RESOURCE-GROUP-NAME'
$workspaceName = 'YOUR-WORKSPACE-NAME'
$workspaceResourceId = '/subscriptions/YOUR-SUBSCRIPTION-ID/resourceGroups/YOUR-RESOURCE-GROUP-NAME/providers/Microsoft.OperationalInsights/workspaces/YOUR-WORKSPACE-NAME'
$dataCollectionEndpointId = '/subscriptions/YOUR-SUBSCRIPTION-ID/resourceGroups/YOUR-RESOURCE-GROUP-NAME/providers/Microsoft.Insights/dataCollectionEndpoints/YOUR-DCE-NAME'
$servicePrincipalObjectId = 'YOUR-SERVICE-PRINCIPAL-OBJECT-ID'
$location = 'Australia East'



# Script Configuration
$dcrDirectory = Join-Path $PSScriptRoot "dcr-from-log-analytics-all"
$whatIfMode = $false          # Set to $true to validate templates without deploying
$testMode = $false            # Set to $true to only test a few DCRs first
$maxRetries = 1               # Number of retries for failed deployments
$retryDelaySeconds = 30       # Delay between retries

# Filtering options (leave empty to test all DCRs)
$includeOnly = @()            # Specify table names to test only specific DCRs, e.g., @('Syslog', 'Anomalies')
$excludeTables = @()          # Specify table names to exclude from testing

# Error handling
$ErrorActionPreference = "Continue"  # Continue on errors to test all DCRs

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

function Get-TableNameFromBicepFile {
    param([string]$bicepFilePath)
    
    # Extract table name from file path - assuming structure like dcr/TableName/dcr-TableName.bicep
    $parentDir = Split-Path (Split-Path $bicepFilePath -Parent) -Leaf
    if ($parentDir -eq "dcr") {
        # File is directly in dcr directory
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($bicepFilePath)
        return $fileName -replace '^dcr-', ''
    } else {
        # File is in a subdirectory
        return $parentDir
    }
}

function Test-DCRDeployment {
    param(
        [string]$bicepFilePath,
        [string]$tableName,
        [hashtable]$deploymentParams,
        [int]$attempt = 1
    )
    
    $deploymentName = "test-dcr-$tableName-$(Get-Date -Format 'yyyyMMdd-HHmmss')-attempt$attempt"
    
    try {
        Write-LogMessage "Attempting deployment $attempt for $tableName..." "INFO"
        
        if ($whatIfMode) {
            $result = Test-AzResourceGroupDeployment -ResourceGroupName $deploymentParams.ResourceGroupName -TemplateFile $bicepFilePath -Location $deploymentParams.Location -workspaceName $deploymentParams.WorkspaceName -workspaceResourceId $deploymentParams.WorkspaceResourceId -dataCollectionEndpointId $deploymentParams.DataCollectionEndpointId -servicePrincipalObjectId $deploymentParams.ServicePrincipalObjectId -ErrorAction Stop
            
            if ($result) {
                return @{
                    Success = $false
                    Error = "Template validation failed: $($result.Details)"
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
            $deployment = New-AzResourceGroupDeployment -ResourceGroupName $deploymentParams.ResourceGroupName -Name $deploymentName -TemplateFile $bicepFilePath -Location $deploymentParams.Location -workspaceName $deploymentParams.WorkspaceName -workspaceResourceId $deploymentParams.WorkspaceResourceId -dataCollectionEndpointId $deploymentParams.DataCollectionEndpointId -servicePrincipalObjectId $deploymentParams.ServicePrincipalObjectId -ErrorAction Stop
            
            return @{
                Success = $true
                DeploymentName = $deploymentName
                Attempt = $attempt
                ResourceId = $deployment.Outputs.dataCollectionRuleId.Value
                ImmutableId = $deployment.Outputs.immutableId.Value
            }
        }
    } catch {
        $errorMessage = $_.Exception.Message
        $errorDetails = ""
        
        # Extract more detailed error information
        if ($_.Exception.InnerException) {
            $errorDetails = $_.Exception.InnerException.Message
        }
        
        # Check for specific DCR-related errors
        $isOutputStreamError = $errorMessage -match "output.*stream" -or $errorMessage -match "Microsoft-.*not.*supported"
        $isPermissionError = $errorMessage -match "permission" -or $errorMessage -match "authorization"
        $isResourceError = $errorMessage -match "resource.*not.*found" -or $errorMessage -match "does.*not.*exist"
        
        return @{
            Success = $false
            Error = $errorMessage
            ErrorDetails = $errorDetails
            DeploymentName = $deploymentName
            Attempt = $attempt
            IsOutputStreamError = $isOutputStreamError
            IsPermissionError = $isPermissionError
            IsResourceError = $isResourceError
        }
    }
}

function Remove-TestDCR {
    param(
        [string]$resourceId,
        [string]$tableName
    )
    
    if ($resourceId) {
        try {
            Write-LogMessage "Cleaning up test DCR for $tableName..." "INFO"
            Remove-AzResource -ResourceId $resourceId -Force -Confirm:$false
            Write-LogMessage "Successfully removed test DCR for $tableName" "SUCCESS"
        } catch {
            Write-LogMessage "Failed to remove test DCR for $tableName : $($_.Exception.Message)" "WARN"
        }
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-LogMessage "Bulk DCR Deployment Test Script" "INFO"
Write-LogMessage "=================================" "INFO"

Write-LogMessage "Configuration:" "INFO"
Write-LogMessage "  Resource Group: $resourceGroupName" "INFO"
Write-LogMessage "  Workspace: $workspaceName" "INFO"
Write-LogMessage "  DCR Directory: $dcrDirectory" "INFO"
Write-LogMessage "  What-If Mode: $whatIfMode" "INFO"
Write-LogMessage "  Test Mode: $testMode" "INFO"

# Validate prerequisites
if (-not (Get-Module -ListAvailable -Name Az.Resources)) {
    Write-LogMessage "Az.Resources module not found. Install with: Install-Module Az.Resources" "ERROR"
    throw 1
}

if (-not (Get-Module Az.Resources)) {
    Import-Module Az.Resources
}

# Check Azure context
$context = Get-AzContext
if (-not $context) {
    Write-LogMessage "Not logged into Azure. Please run Connect-AzAccount" "ERROR"
    throw 1
}

Write-LogMessage "Authenticated as: $($context.Account.Id)" "SUCCESS"

# Validate configuration
if ($resourceGroupName -eq 'YOUR-RESOURCE-GROUP-NAME') {
    Write-LogMessage "Please update the configuration section with your actual Azure resource details" "ERROR"
    throw 1
}

# Validate DCR directory
if (-not (Test-Path $dcrDirectory)) {
    Write-LogMessage "DCR directory not found: $dcrDirectory" "ERROR"
    throw 1
}

# Find all Bicep files
Write-LogMessage "Discovering Bicep files in $dcrDirectory..." "INFO"
$bicepFiles = Get-ChildItem -Path $dcrDirectory -Filter "*.bicep" -Recurse | Where-Object {
    $_.Name -match '^dcr-.*\.bicep$'  # Only DCR files, not parameters
}

if ($bicepFiles.Count -eq 0) {
    Write-LogMessage "No DCR Bicep files found in $dcrDirectory" "ERROR"
    exit 1
}

Write-LogMessage "Found $($bicepFiles.Count) DCR Bicep files" "SUCCESS"

# Filter files based on configuration
$filteredFiles = $bicepFiles
if ($includeOnly.Count -gt 0) {
    $filteredFiles = $bicepFiles | Where-Object {
        $tableName = Get-TableNameFromBicepFile $_.FullName
        $tableName -in $includeOnly
    }
    Write-LogMessage "Filtered to $($filteredFiles.Count) files based on include list" "INFO"
}

if ($excludeTables.Count -gt 0) {
    $filteredFiles = $filteredFiles | Where-Object {
        $tableName = Get-TableNameFromBicepFile $_.FullName
        $tableName -notin $excludeTables
    }
    Write-LogMessage "Filtered to $($filteredFiles.Count) files after exclusions" "INFO"
}

if ($testMode -and $filteredFiles.Count -gt 5) {
    $filteredFiles = $filteredFiles | Select-Object -First 5
    Write-LogMessage "Test mode: Limited to first 5 files" "INFO"
}

# Prepare deployment parameters
$deploymentParams = @{
    ResourceGroupName = $resourceGroupName
    Location = $location
    WorkspaceName = $workspaceName
    WorkspaceResourceId = $workspaceResourceId
    DataCollectionEndpointId = $dataCollectionEndpointId
    ServicePrincipalObjectId = $servicePrincipalObjectId
}

# Track results
$results = @()
$successCount = 0
$failureCount = 0
$microsoftTableSuccesses = @()
$microsoftTableFailures = @()
$customTableSuccesses = @()
$customTableFailures = @()

Write-LogMessage "Starting deployment tests..." "INFO"
Write-LogMessage "============================" "INFO"

foreach ($bicepFile in $filteredFiles) {
    $tableName = Get-TableNameFromBicepFile $bicepFile.FullName
    Write-LogMessage "Testing DCR for table: $tableName" "INFO"
    
    # Determine if this is likely a Microsoft or Custom table
    $isMicrosoftTable = $tableName -notmatch "_CL$"
    $tableType = if ($isMicrosoftTable) { "Microsoft" } else { "Custom" }
    
    $deploymentResult = $null
    $finalAttempt = 1
    
    # Retry logic
    for ($attempt = 1; $attempt -le $maxRetries; $attempt++) {
        $deploymentResult = Test-DCRDeployment -bicepFilePath $bicepFile.FullName -tableName $tableName -deploymentParams $deploymentParams -attempt $attempt
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
        
        if ($isMicrosoftTable) {
            $microsoftTableSuccesses += $tableName
        } else {
            $customTableSuccesses += $tableName
        }
        
        # Clean up test DCR if not in what-if mode
        if (-not $whatIfMode -and $deploymentResult.ResourceId) {
            Remove-TestDCR -resourceId $deploymentResult.ResourceId -tableName $tableName
        }
    } else {
        $failureCount++
        Write-LogMessage "FAILED: $tableName ($tableType table) - $($deploymentResult.Error)" "ERROR"
        
        if ($isMicrosoftTable) {
            $microsoftTableFailures += @{
                TableName = $tableName
                Error = $deploymentResult.Error
                IsOutputStreamError = $deploymentResult.IsOutputStreamError
            }
        } else {
            $customTableFailures += @{
                TableName = $tableName
                Error = $deploymentResult.Error
                IsOutputStreamError = $deploymentResult.IsOutputStreamError
            }
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
        IsOutputStreamError = $deploymentResult.IsOutputStreamError
        IsPermissionError = $deploymentResult.IsPermissionError
        IsResourceError = $deploymentResult.IsResourceError
        BicepFile = $bicepFile.FullName
    }
}

# ============================================================================
# SUMMARY REPORT
# ============================================================================

Write-LogMessage "" "INFO"
Write-LogMessage "BULK DCR DEPLOYMENT TEST SUMMARY" "INFO"
Write-LogMessage "=================================" "INFO"
Write-LogMessage "" "INFO"

Write-LogMessage "Overall Results:" "INFO"
Write-LogMessage "  Total DCRs Tested: $($filteredFiles.Count)" "INFO"
Write-LogMessage "  Successful Deployments: $successCount" "SUCCESS"
Write-LogMessage "  Failed Deployments: $failureCount" "ERROR"
Write-LogMessage "  Success Rate: $([math]::Round(($successCount / $filteredFiles.Count) * 100, 1))%" "INFO"
Write-LogMessage "" "INFO"

Write-LogMessage "Microsoft Table Results:" "INFO"
Write-LogMessage "  Successful: $($microsoftTableSuccesses.Count)" "SUCCESS"
Write-LogMessage "  Failed: $($microsoftTableFailures.Count)" "ERROR"
Write-LogMessage "" "INFO"

if ($microsoftTableSuccesses.Count -gt 0) {
    Write-LogMessage "Writable Microsoft Tables (Microsoft- output stream works):" "SUCCESS"
    foreach ($table in $microsoftTableSuccesses) {
        Write-LogMessage "  $table" "SUCCESS"
    }
    Write-LogMessage "INFO"
}

if ($microsoftTableFailures.Count -gt 0) {
    Write-LogMessage "Failed Microsoft Tables:" "ERROR"
    foreach ($failure in $microsoftTableFailures) {
        $errorType = if ($failure.IsOutputStreamError) { " (OUTPUT STREAM ERROR)" } else { "" }
        Write-LogMessage "$($failure.TableName)$errorType" "ERROR"
        Write-LogMessage "    Error: $($failure.Error)" "ERROR"
    }
    Write-LogMessage "" "INFO"
}

Write-LogMessage "Custom Table Results:" "INFO"
Write-LogMessage "  Successful: $($customTableSuccesses.Count)" "SUCCESS"
Write-LogMessage "  Failed: $($customTableFailures.Count)" "ERROR"
Write-LogMessage "" "INFO"

if ($customTableSuccesses.Count -gt 0) {
    Write-LogMessage "Working Custom Tables:" "SUCCESS"
    foreach ($table in $customTableSuccesses) {
        Write-LogMessage "   $table SUCCESS" "SUCCESS"
    }
    Write-LogMessage " INFO"
}

# Analysis of output stream errors
$outputStreamErrors = $results | Where-Object { $_.IsOutputStreamError }
if ($outputStreamErrors.Count -gt 0) {
    Write-LogMessage "Output Stream Errors Analysis:" "WARN"
    Write-LogMessage "The following tables failed due to output stream issues:" "WARN"
    foreach ($errormsg in $outputStreamErrors) {
        Write-LogMessage "  - $($errormsg.TableName) ($($errormsg.TableType))" "WARN"
    }
    Write-LogMessage "" "INFO"
    Write-LogMessage "These errors suggest the output stream logic needs adjustment." "WARN"
    Write-LogMessage "" "INFO"
}

# Recommendations
Write-LogMessage "Recommendations:" "INFO"
if ($microsoftTableSuccesses.Count -gt 0) {
    Write-LogMessage " Confirmed writable Microsoft tables - update Get-DCROutputStreamName function" "SUCCESS"
}

if ($microsoftTableFailures.Count -gt 0) {
    $outputStreamFailures = $microsoftTableFailures | Where-Object { $_.IsOutputStreamError }
    if ($outputStreamFailures.Count -gt 0) {
        Write-LogMessage " Some Microsoft tables failed with output stream errors - may need Custom- prefix" "WARN"
    }
}

Write-LogMessage " " "INFO"
Write-LogMessage "Detailed results available in `$results variable" "INFO"

if ($whatIfMode) {
    Write-LogMessage "Note: What-If mode was enabled - no actual deployments were made" "INFO"
} else {
    Write-LogMessage "Note: Test DCRs were deployed and cleaned up automatically" "INFO"
}

Write-LogMessage "" "INFO"
Write-LogMessage "Test completed at $(Get-Date)" "INFO"

# Export results to CSV for further analysis
$csvPath = Join-Path $PSScriptRoot "dcr-deployment-test-results-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation
Write-LogMessage "Detailed results exported to: $csvPath INFO"