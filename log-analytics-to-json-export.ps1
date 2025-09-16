# ============================================================================
# Log Analytics to JSON Schema Export Script - UPDATED VERSION
# ============================================================================
# Exports Log Analytics table schemas as JSON files
# Uses hybrid approach combining Management API + getschema for complete coverage
#
# Prerequisites: Az.Accounts, Az.OperationalInsights modules and Azure authentication
# Usage: Update configuration below and run script
# ============================================================================

# Import common functions module
$modulePath = Join-Path $PSScriptRoot "LogAnalyticsCommon.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
} else {
    throw "ERROR: LogAnalyticsCommon.psm1 module not found at: $modulePath"
}

# ============================================================================
# CONFIGURATION - UPDATE THESE VALUES FOR YOUR ENVIRONMENT
# ============================================================================

# Azure Configuration
$workspaceName = 'YOUR-WORKSPACE-NAME'
$resourceGroupName = 'YOUR-RESOURCE-GROUP-NAME'
$subscriptionId = 'YOUR-SUBSCRIPTION-ID'
$tenantId = ''  # Optional - leave empty to use current context

# Export Configuration
$ExportAll = $true                    # Set to $true to export ALL workspace tables

# Column filtering options
$FilterUnderscoreColumns = $false     # Set to $false to include underscore columns in JSON

# Specific tables to export (ignored if ExportAll is $true)
$tablesToExport = @(
    'Anomalies',
    'ASimAuditEventLogs',
    'ASimAuthenticationEventLogs',
    'ASimDhcpEventLogs',
    'ASimDnsActivityLogs',
    'ASimFileEventLogs',
    'ASimNetworkSessionLogs',
    'ASimProcessEventLogs',
    'ASimRegistryEventLogs',
    'ASimUserManagementActivityLogs',
    'ASimWebSessionLogs',
    'AWSCloudTrail',
    'AWSCloudWatch',
    'AWSGuardDuty',
    'AWSVPCFlow',
    'CommonSecurityLog',    
    'GCPAuditLogs',
    'GoogleCloudSCC',
    'SecurityEvent',
    'Syslog',
    'WindowsEvent'
)

# Output directories
$outputDirectory = $PSScriptRoot
$jsonDirectory = Join-Path $outputDirectory "json-exports-from-log-analytics"

# Enhanced discovery settings
$useHybridDiscovery = $true
$preferManagementAPITypes = $true
$ErrorActionPreference = "Stop"

# ============================================================================
# JSON EXPORT FUNCTIONS
# ============================================================================

function Convert-ToJSONType {
    <#
    .SYNOPSIS
    Converts Log Analytics type to JSON export type
    #>
    param([string]$laType)
    
    switch ($laType.ToLower()) {
        'string' { return 'String' }
        'datetime' { return 'DateTime' }
        'int' { return 'Int' }
        'long' { return 'Long' }
        'real' { return 'Double' }
        'bool' { return 'Boolean' }
        'boolean' { return 'Boolean' }
        'dynamic' { return 'Dynamic' }
        'guid' { return 'Guid' }
        'timespan' { return 'TimeSpan' }
        default { return 'String' }
    }
}

function New-OrderedJSONSchema {
    <#
    .SYNOPSIS
    Creates ordered JSON schema following Microsoft conventions
    #>
    param([string]$tableName, [array]$columnDefinitions, [bool]$filterUnderscore = $false)
    
    # Apply column filtering based on FilterUnderscoreColumns setting
    if ($filterUnderscore) {
        $filteredColumns = $columnDefinitions | Where-Object { -not $_.name.StartsWith("_") }
        $removedCount = $columnDefinitions.Count - $filteredColumns.Count
        if ($removedCount -gt 0) {
            Write-Host "    Filtered out $removedCount underscore columns" -ForegroundColor Yellow
        }
    } else {
        $filteredColumns = $columnDefinitions
    }
    
    # Sort columns following Microsoft's convention:
    # 1. TimeGenerated first
    # 2. Regular columns (alphabetical)
    # 3. Type column (if present) 
    # 4. Underscore columns (_ResourceId, etc.)
    
    $timeGeneratedCol = $filteredColumns | Where-Object { $_.name -eq "TimeGenerated" }
    $typeCol = $filteredColumns | Where-Object { $_.name -eq "Type" }
    $underscoreCols = $filteredColumns | Where-Object { $_.name -like "_*" -and $_.name -ne "TimeGenerated" -and $_.name -ne "Type" } | Sort-Object name
    $regularCols = $filteredColumns | Where-Object { $_.name -ne "TimeGenerated" -and $_.name -ne "Type" -and $_.name -notlike "_*" } | Sort-Object name
    
    # Build ordered column list
    $sortedColumns = @()
    if ($timeGeneratedCol) { $sortedColumns += $timeGeneratedCol }
    $sortedColumns += $regularCols
    if ($typeCol) { $sortedColumns += $typeCol }
    $sortedColumns += $underscoreCols
    
    # Convert to proper JSON format with correct type casing
    $jsonProperties = @()
    foreach ($column in $sortedColumns) {
        $jsonProperties += @{
            Name = $column.name
            Type = Convert-ToJSONType -laType $column.type
        }
    }
    
    # Create the JSON structure with Name FIRST (PowerShell hashtable order matters for JSON output)
    $jsonSchema = [ordered]@{
        Name = $tableName
        Properties = $jsonProperties
    }
    
    return $jsonSchema
}

function Get-AllWorkspaceTables {
    <#
    .SYNOPSIS
    Gets all table names from the workspace
    #>
    param([hashtable]$authHeaders, [string]$subscriptionId, [string]$resourceGroupName, [string]$workspaceName)
    
    try {
        Write-Host "  Discovering all workspace tables..." -ForegroundColor Gray
        $apiUri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName/providers/microsoft.operationalinsights/workspaces/$workspaceName/tables?api-version=2023-09-01"
        $response = Invoke-RestMethod -Method Get -Headers $authHeaders -Uri $apiUri -UseBasicParsing
        
        $tableNames = @()
        if ($response.value) {
            foreach ($table in $response.value) {
                if ($table.name) {
                    $tableNames += $table.name
                }
            }
        }
        
        Write-Host "  Found $($tableNames.Count) tables in workspace" -ForegroundColor Gray
        return $tableNames | Sort-Object
    } catch {
        Write-Warning "Failed to get all workspace tables: $($_.Exception.Message)"
        return @()
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-Host "Log Analytics to JSON Export Script - UPDATED VERSION" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  Workspace: $workspaceName"
Write-Host "  Resource Group: $resourceGroupName"
Write-Host "  Subscription: $subscriptionId"
Write-Host "  Export All Tables: $ExportAll"
Write-Host "  Filter Underscore Columns: $FilterUnderscoreColumns"
Write-Host "  Hybrid Discovery: $useHybridDiscovery"

# Validate and prepare
if (-not $workspaceName -or -not $resourceGroupName -or -not $subscriptionId) {
    throw "ERROR: Configuration values cannot be empty"
}

if (-not (Test-Path $jsonDirectory)) { 
    New-Item -Path $jsonDirectory -ItemType Directory -Force | Out-Null 
    Write-Host "Created JSON directory: $jsonDirectory" -ForegroundColor Green
}

# Test prerequisites and authenticate
Write-Host "`nTesting prerequisites and authentication..." -ForegroundColor Yellow
$context = Test-PrerequisitesAndAuth -subscriptionId $subscriptionId -tenantId $tenantId
Write-Host "SUCCESS: Authenticated as $($context.Account.Id)" -ForegroundColor Green

# Get tokens
Write-Host "`nAcquiring access tokens..." -ForegroundColor Yellow
$managementTokenString = Get-SafeAccessToken -ResourceUrl "https://management.azure.com/"
$managementHeaders = @{ 'Content-Type' = 'application/json'; 'Authorization' = "Bearer $managementTokenString"; 'Accept' = 'application/json' }
Write-Host "SUCCESS: Management API token acquired" -ForegroundColor Green

if ($useHybridDiscovery) {
    $laTokenString = Get-SafeAccessToken -ResourceUrl "https://api.loganalytics.io/"
    $queryHeaders = @{ 'Authorization' = "Bearer $laTokenString"; 'Content-Type' = 'application/json' }
    Write-Host "SUCCESS: Log Analytics API token acquired" -ForegroundColor Green
    
    $workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $workspaceName
    $workspaceGuid = $workspace.CustomerId
    Write-Host "SUCCESS: Workspace GUID: $workspaceGuid" -ForegroundColor Green
}

# Determine which tables to export
if ($ExportAll) {
    Write-Host "`nDiscovering all workspace tables..." -ForegroundColor Yellow
    $allTables = Get-AllWorkspaceTables -authHeaders $managementHeaders -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName -workspaceName $workspaceName
    
    if ($allTables.Count -eq 0) {
        throw "ERROR: No tables found in workspace or failed to enumerate tables"
    }
    
    $finalTablesToExport = $allTables
    Write-Host "SUCCESS: Found $($finalTablesToExport.Count) tables to export" -ForegroundColor Green
} else {
    # Use the configured table list
    Write-Host "`nUsing configured table list..." -ForegroundColor Yellow
    $finalTablesToExport = $tablesToExport
    Write-Host "SUCCESS: $($finalTablesToExport.Count) configured tables to export" -ForegroundColor Green
}

# Show tables to export
if ($finalTablesToExport.Count -le 15) {
    Write-Host "`nTables to Export:" -ForegroundColor Cyan
    $finalTablesToExport | ForEach-Object { Write-Host "  * $_" -ForegroundColor White }
} else {
    Write-Host "`nExporting $($finalTablesToExport.Count) tables (showing first 15):" -ForegroundColor Cyan
    $finalTablesToExport | Select-Object -First 15 | ForEach-Object { Write-Host "  * $_" -ForegroundColor White }
    Write-Host "  ... and $($finalTablesToExport.Count - 15) more" -ForegroundColor Gray
}

# Export JSON schemas
Write-Host "`nGenerating JSON schemas..." -ForegroundColor Yellow
$exportResults = @()
$successCount = 0
$failureCount = 0

foreach ($tableName in $finalTablesToExport) {
    try {
        Write-Host "Processing: $tableName" -ForegroundColor Cyan
        
        $managementResult = Get-ManagementAPIColumns -tableName $tableName -authHeaders $managementHeaders -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName -workspaceName $workspaceName
        
        $getSchemaResult = @{ columns = @(); success = $false }
        if ($useHybridDiscovery -and $managementResult.success) {
            $getSchemaResult = Get-GetSchemaColumns -tableName $tableName -workspaceGuid $workspaceGuid -queryHeaders $queryHeaders
        }
        
        if ($managementResult.success) {
            if ($useHybridDiscovery -and $getSchemaResult.success) {
                # Hybrid approach: merge both sources
                $mergeResult = Merge-ColumnSources -managementColumns $managementResult.columns -getSchemaColumns $getSchemaResult.columns -preferManagementTypes $preferManagementAPITypes
                $finalColumns = $mergeResult.columns
                $actualAdditionalCount = $mergeResult.additionalCount
                $discoveryMethod = "Hybrid"
            } else {
                # Management API only
                $finalColumns = $managementResult.columns
                $actualAdditionalCount = 0
                $discoveryMethod = "Management API only"
            }
            $tableType = $managementResult.tableType
        } else {
            throw "Management API failed for table: $tableName"
        }
        
        if ($finalColumns.Count -eq 0) { throw "No columns found" }
        
        $jsonSchema = New-OrderedJSONSchema -tableName $tableName -columnDefinitions $finalColumns -filterUnderscore $FilterUnderscoreColumns
        $jsonFile = Join-Path $jsonDirectory "$tableName.json"
        $jsonSchema | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonFile -Encoding UTF8 -Force
        
        $mgmtCount = ($finalColumns | Where-Object { $_.source -eq "ManagementAPI" }).Count
        $schemaCount = $actualAdditionalCount
        
        # Calculate final column count after filtering
        $finalColumnCount = $jsonSchema.Properties.Count
        
        $columnFilterMsg = if ($FilterUnderscoreColumns) { "filtered" } else { "unfiltered" }
        Write-Host "  SUCCESS: $($finalColumns.Count) total columns -> $finalColumnCount JSON columns ($mgmtCount mgmt, $schemaCount additional) -> $tableName.json ($columnFilterMsg)" -ForegroundColor Green
        
        $exportResults += [PSCustomObject]@{
            TableName = $tableName
            TotalColumnCount = $finalColumns.Count
            JSONColumnCount = $finalColumnCount
            ManagementAPICount = $mgmtCount
            GetSchemaCount = $schemaCount
            TableType = $tableType
            Status = "Success"
            DiscoveryMethod = $discoveryMethod
        }
        $successCount++
        
    } catch {
        Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
        $exportResults += [PSCustomObject]@{ 
            TableName = $tableName
            Status = "Failed"
            Error = $_.Exception.Message
            GetSchemaCount = 0 
        }
        $failureCount++
    }
}

# Summary
Write-Host "`nExport Summary:" -ForegroundColor Magenta
Write-Host "===============" -ForegroundColor Magenta
Write-Host "SUCCESS: $successCount/$($finalTablesToExport.Count) tables exported" -ForegroundColor Green

if ($failureCount -gt 0) {
    Write-Host "FAILED: $failureCount tables failed" -ForegroundColor Red
}

$totalDiscovered = ($exportResults | Where-Object { $_.Status -eq "Success" } | ForEach-Object { $_.GetSchemaCount } | Measure-Object -Sum).Sum
if ($totalDiscovered -gt 0) {
    Write-Host "Additional columns discovered: $totalDiscovered" -ForegroundColor Cyan
}

if ($successCount -gt 0) {
    Write-Host "`nSuccessful Exports:" -ForegroundColor Green
    $exportResults | Where-Object { $_.Status -eq "Success" } | Sort-Object TableName | ForEach-Object {
        $additionalInfo = if ($_.GetSchemaCount -gt 0) { " (+$($_.GetSchemaCount) additional)" } else { "" }
        $filterInfo = if ($_.JSONColumnCount -ne $_.TotalColumnCount) { " -> $($_.JSONColumnCount) JSON columns" } else { "" }
        Write-Host "  * $($_.TableName): $($_.TotalColumnCount) total columns$filterInfo$additionalInfo" -ForegroundColor White
    }
}

if ($failureCount -gt 0) {
    Write-Host "`nFailed Exports:" -ForegroundColor Red
    $exportResults | Where-Object { $_.Status -eq "Failed" } | ForEach-Object {
        Write-Host "  * $($_.TableName): $($_.Error)" -ForegroundColor Red
    }
}

Write-Host "`nConfiguration Options:" -ForegroundColor Cyan
Write-Host "- Set `$ExportAll = `$true to export all workspace tables" -ForegroundColor White
Write-Host "- Set `$ExportAll = `$false to use the configured table list" -ForegroundColor White
Write-Host "- Set `$FilterUnderscoreColumns = `$false to include underscore columns" -ForegroundColor White

Write-Host "`nJSON files created in json-exports\ directory for use with json-to-* scripts." -ForegroundColor White
Write-Host "JSON Export completed with enhanced discovery capabilities." -ForegroundColor White