# ============================================================================
# Log Analytics to Azure Data Explorer KQL Export Script - UPDATED VERSION
# ============================================================================
# Exports Log Analytics table schemas as KQL scripts for Azure Data Explorer
# Uses hybrid approach combining Management API + getschema for complete coverage
#
# Incorporates lessons learned from empirical DCR and table deployment testing:
# - Fixes Microsoft API bugs (TenantId String->Guid, Double->real)
# - ExportAll and FilterUnderscoreTables configuration options
# - Enhanced error handling and data type corrections
# - Consistent underscore filtering logic
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
$FilterUnderscoreTables = $false        # Set to $false to include underscore tables/columns

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
    'WindowsEvent',
    'OktaV2_CL',
    'GCP_DNS_CL',
    'ZeroFoxAlertPoller_CL'
)

# Output directories
$outputDirectory = $PSScriptRoot
$kqlDirectory = Join-Path $outputDirectory "kql-complete"

# ADX Configuration
$rawTableRetention = "1d"
$rawTableCaching = "1h"
$mainTableCaching = "1d"

# Enhanced discovery settings
$useHybridDiscovery = $true
$preferManagementAPITypes = $true
$ErrorActionPreference = "Stop"

# ============================================================================
# DATA TYPE CORRECTION FUNCTIONS (NEW)
# ============================================================================

function Apply-MicrosoftAPIBugFixes {
    <#
    .SYNOPSIS
    Applies corrections for known Microsoft Log Analytics schema export API bugs
    
    .PARAMETER columns
    Array of column definitions from Management API
    #>
    param([array]$columns)
    
    $correctedColumns = @()
    $fixCount = 0
    
    foreach ($column in $columns) {
        $originalType = $column.type
        $correctedType = $originalType
        
        # Fix well-known Microsoft API bugs
        switch ($column.name) {
            "TenantId" {
                if ($originalType -eq "string") {
                    $correctedType = "guid"
                    $fixCount++
                    Write-Host "    Fixed Microsoft API bug: TenantId $originalType -> $correctedType" -ForegroundColor Yellow
                }
            }
            "WorkspaceId" {
                if ($originalType -eq "string") {
                    $correctedType = "guid"
                    $fixCount++
                    Write-Host "    Fixed Microsoft API bug: WorkspaceId $originalType -> $correctedType" -ForegroundColor Yellow
                }
            }
            "TimeGenerated" {
                if ($originalType -eq "string") {
                    $correctedType = "datetime"
                    $fixCount++
                    Write-Host "    Fixed Microsoft API bug: TimeGenerated $originalType -> $correctedType" -ForegroundColor Yellow
                }
            }
        }
        
        # Fix global type mapping issues
        if ($originalType -eq "double") {
            $correctedType = "real" 
            $fixCount++
            Write-Host "    Fixed type mapping: $($column.name) Double -> real (ADX/Log Analytics standard)" -ForegroundColor Yellow
        }
        
        # Create corrected column
        $correctedColumn = @{
            name = $column.name
            type = $correctedType
            description = $column.description
            source = $column.source
        }
        
        $correctedColumns += $correctedColumn
    }
    
    if ($fixCount -gt 0) {
        Write-Host "  Applied $fixCount Microsoft API bug fixes" -ForegroundColor Green
    }
    
    return $correctedColumns
}

function Get-AllWorkspaceTables {
    <#
    .SYNOPSIS
    Gets all table names from the workspace
    #>
    param([hashtable]$authHeaders, [string]$subscriptionId, [string]$resourceGroupName, [string]$workspaceName, [bool]$filterUnderscore = $true)
    
    try {
        Write-Host "  Discovering all workspace tables..." -ForegroundColor Gray
        $apiUri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName/providers/microsoft.operationalinsights/workspaces/$workspaceName/tables?api-version=2023-09-01"
        $response = Invoke-RestMethod -Method Get -Headers $authHeaders -Uri $apiUri -UseBasicParsing
        
        $tableNames = @()
        if ($response.value) {
            foreach ($table in $response.value) {
                if ($table.name) {
                    if ($filterUnderscore) {
                        if (-not $table.name.StartsWith("_")) {
                            $tableNames += $table.name
                        }
                    } else {
                        $tableNames += $table.name
                    }
                }
            }
        }
        
        $filterMsg = if ($filterUnderscore) { "non-underscore" } else { "all" }
        Write-Host "  Found $($tableNames.Count) $filterMsg tables in workspace" -ForegroundColor Gray
        return $tableNames | Sort-Object
    } catch {
        Write-Warning "Failed to get all workspace tables: $($_.Exception.Message)"
        return @()
    }
}

function Apply-UnderscoreTableFiltering {
    <#
    .SYNOPSIS
    Applies consistent underscore table filtering
    #>
    param([array]$tableList, [bool]$filterUnderscore, [string]$context = "tables")
    
    if (-not $filterUnderscore) {
        return $tableList
    }
    
    $filteredTables = $tableList | Where-Object { -not $_.StartsWith("_") }
    $excludedCount = $tableList.Count - $filteredTables.Count
    
    if ($excludedCount -gt 0) {
        Write-Host "  Filtered out $excludedCount underscore $context" -ForegroundColor Yellow
        $excludedTables = $tableList | Where-Object { $_.StartsWith("_") }
        foreach ($table in $excludedTables) {
            Write-Host "    - $table" -ForegroundColor Gray
        }
    }
    
    return $filteredTables
}

# ============================================================================
# ENHANCED KQL GENERATION FUNCTIONS
# ============================================================================

function Generate-KQLScript {
    param([string]$tableName, [array]$columnDefinitions, [string]$tableType = "Unknown", [bool]$isHybrid = $false)
    
    # Apply data type corrections based on empirical discoveries
    $correctedColumns = Apply-MicrosoftAPIBugFixes -columns $columnDefinitions
    
    # Apply column filtering based on FilterUnderscoreTables setting
    if ($FilterUnderscoreTables) {
        $filteredColumns = Filter-NonUnderscoreColumns -columns $correctedColumns
    } else {
        # Keep all columns including underscore columns for ADX (useful for analysis)
        $filteredColumns = $correctedColumns
    }
    
    $rawTableName = "${tableName}Raw"
    $expandFunctionName = "${tableName}Expand"
    $mappingName = "${tableName}RawMapping"
    
    # Sort columns following Microsoft's convention:
    # 1. TimeGenerated first
    # 2. Regular columns (alphabetical)
    # 3. Type column (if present)
    # 4. Underscore columns (_ResourceId, etc.)
    # 5. _TimeReceived last (our addition)
    
    $timeGeneratedCol = $filteredColumns | Where-Object { $_.name -eq "TimeGenerated" }
    $typeCol = $filteredColumns | Where-Object { $_.name -eq "Type" }
    $underscoreCols = $filteredColumns | Where-Object { $_.name -like "_*" } | Sort-Object name
    $regularCols = $filteredColumns | Where-Object { $_.name -ne "TimeGenerated" -and $_.name -ne "Type" -and $_.name -notlike "_*" } | Sort-Object name
    
    # Build ordered column list
    $sortedColumns = @()
    if ($timeGeneratedCol) { $sortedColumns += $timeGeneratedCol }
    $sortedColumns += $regularCols
    if ($typeCol) { $sortedColumns += $typeCol }
    $sortedColumns += $underscoreCols
    
    $mainTableColumns = @()
    $expandProjections = @()
    
    foreach ($column in $sortedColumns) {
        $adxType = Convert-LATypeToADXType -laType $column.type
        $conversionFunc = Get-ADXConversionFunction -laType $column.type
        $mainTableColumns += "$($column.name):$adxType"
        $expandProjections += "$($column.name)=$conversionFunc(events.$($column.name))"
    }
    
    # Add _TimeReceived column last
    $mainTableColumns += "_TimeReceived:datetime"
    $expandProjections += "_TimeReceived=todatetime(now())"
    
    $discoveryComment = if ($isHybrid) { "// Schema discovered using hybrid approach (Management API + getschema)" } else { "// Schema discovered using Management API only" }
    $tableTypeComment = "// Table type: $tableType"
    $correctionsComment = "// Data type corrections applied: TenantId->guid, Double->real (empirical fixes)"
    $filteringComment = if ($FilterUnderscoreTables) { "// Underscore columns filtered out" } else { "// All columns including underscore columns included" }
    
    $kqlScript = @"
// ============================================================================
// Azure Data Explorer KQL Script for $tableName - UPDATED VERSION
// ============================================================================
// Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
$tableTypeComment
$discoveryComment
$correctionsComment
$filteringComment
// Original columns: $($columnDefinitions.Count), Final columns: $($sortedColumns.Count)
// ============================================================================

.create-merge table $rawTableName (records:dynamic)

.alter-merge table $rawTableName policy retention softdelete = $rawTableRetention

.alter table $rawTableName policy caching hot = $rawTableCaching

// JSON mapping - choose appropriate option based on data structure
.create-or-alter table $rawTableName ingestion json mapping '$mappingName' '[{"column":"records","Properties":{"path":"$.records"}}]'
// Alternative for direct events: '[{"column":"records","Properties":{"path":"$"}}]'

.create-merge table $tableName(
$($mainTableColumns -join ",`n"))

.alter table $tableName policy caching hot = $mainTableCaching

.create-or-alter function $expandFunctionName() {
$rawTableName
| mv-expand events = records
// Alternative for non-nested: | extend events = records
| project
$($expandProjections -join ",`n")
}

.alter table $tableName policy update @'[{"Source": "$rawTableName", "Query": "$expandFunctionName()", "IsEnabled": "True", "IsTransactional": true}]'
"@
    return $kqlScript
}

# ============================================================================
# MAIN EXECUTION - ENHANCED
# ============================================================================

Write-Host "Log Analytics to ADX KQL Export Script - UPDATED VERSION" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "Incorporates lessons learned from DCR and table deployment testing" -ForegroundColor Gray

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  Workspace: $workspaceName"
Write-Host "  Resource Group: $resourceGroupName"
Write-Host "  Subscription: $subscriptionId"
Write-Host "  Export All Tables: $ExportAll"
Write-Host "  Filter Underscore Tables: $FilterUnderscoreTables"
Write-Host "  Hybrid Discovery: $useHybridDiscovery"
Write-Host "  Microsoft API Bug Fixes: Enabled (TenantId->Guid, Double->real)"

# Validate and prepare
if (-not $workspaceName -or -not $resourceGroupName -or -not $subscriptionId) {
    throw "ERROR: Configuration values cannot be empty"
}

if (-not (Test-Path $kqlDirectory)) { 
    New-Item -Path $kqlDirectory -ItemType Directory -Force | Out-Null 
    Write-Host "Created KQL directory: $kqlDirectory" -ForegroundColor Green
}

# Test prerequisites and authenticate
Write-Host "`nTesting prerequisites and authentication..." -ForegroundColor Yellow
$context = Test-PrerequisitesAndAuth -subscriptionId $subscriptionId -tenantId $tenantId
Write-Host "SUCCESS: Authenticated as $($context.Account.Id)" -ForegroundColor Green

# Get tokens using future-compatible method
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

# Determine which tables to export with consistent underscore filtering
if ($ExportAll) {
    Write-Host "`nDiscovering all workspace tables..." -ForegroundColor Yellow
    $allTables = Get-AllWorkspaceTables -authHeaders $managementHeaders -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName -workspaceName $workspaceName -filterUnderscore $FilterUnderscoreTables
    
    if ($allTables.Count -eq 0) {
        $tableTypeMsg = if ($FilterUnderscoreTables) { "non-underscore tables" } else { "tables" }
        throw "ERROR: No $tableTypeMsg found in workspace or failed to enumerate tables"
    }
    
    $finalTablesToExport = $allTables
    $tableTypeMsg = if ($FilterUnderscoreTables) { "non-underscore tables" } else { "tables" }
    Write-Host "SUCCESS: Found $($finalTablesToExport.Count) $tableTypeMsg to export" -ForegroundColor Green
} else {
    # Apply consistent underscore filtering to the configured list
    Write-Host "`nApplying table filtering to configured list..." -ForegroundColor Yellow
    $finalTablesToExport = Apply-UnderscoreTableFiltering -tableList $tablesToExport -filterUnderscore $FilterUnderscoreTables -context "tables from configured list"
    
    $filterMsg = if ($FilterUnderscoreTables) { "filtered" } else { "unfiltered" }
    Write-Host "SUCCESS: $($finalTablesToExport.Count) $filterMsg configured tables to export" -ForegroundColor Green
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

# Export KQL scripts with corrections
Write-Host "`nGenerating KQL scripts with data type corrections..." -ForegroundColor Yellow
$exportResults = @()
$successCount = 0
$failureCount = 0
$totalCorrections = 0

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
        
        $mgmtCount = ($finalColumns | Where-Object { $_.source -eq "ManagementAPI" }).Count
        $schemaCount = $actualAdditionalCount
        
        $kqlScript = Generate-KQLScript -tableName $tableName -columnDefinitions $finalColumns -tableType $tableType -isHybrid $useHybridDiscovery
        $kqlFile = Join-Path $kqlDirectory "$tableName.kql"
        $kqlScript | Out-File -FilePath $kqlFile -Encoding UTF8 -Force
        
        $columnFilterMsg = if ($FilterUnderscoreTables) { "filtered" } else { "unfiltered" }
        Write-Host "  SUCCESS: $($finalColumns.Count) columns ($mgmtCount mgmt, $schemaCount additional) -> $tableName.kql ($columnFilterMsg)" -ForegroundColor Green
        
        $exportResults += [PSCustomObject]@{
            TableName = $tableName
            ColumnCount = $finalColumns.Count
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

Write-Host "`nImprovements Applied:" -ForegroundColor Cyan
Write-Host "- Microsoft API bug fixes (TenantId->Guid, TimeGenerated->DateTime, Double->real)" -ForegroundColor White
Write-Host "- ExportAll variable support for complete workspace export" -ForegroundColor White
Write-Host "- Consistent underscore filtering with FilterUnderscoreTables variable" -ForegroundColor White
Write-Host "- Enhanced error handling and data type corrections" -ForegroundColor White
Write-Host "- Corrected ADX type mappings for accurate KQL generation" -ForegroundColor White

if ($successCount -gt 0) {
    Write-Host "`nSuccessful Exports:" -ForegroundColor Green
    $exportResults | Where-Object { $_.Status -eq "Success" } | Sort-Object TableName | ForEach-Object {
        $additionalInfo = if ($_.GetSchemaCount -gt 0) { " (+$($_.GetSchemaCount) additional)" } else { "" }
        Write-Host "  * $($_.TableName): $($_.ColumnCount) columns$additionalInfo" -ForegroundColor White
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
Write-Host "- Set `$FilterUnderscoreTables = `$false to include underscore tables/columns" -ForegroundColor White
Write-Host "- Both settings work together for flexible export control" -ForegroundColor White

Write-Host "`nFiles created in kql\ directory. Run scripts in ADX to create tables." -ForegroundColor White
Write-Host "ADX KQL Export completed with empirical improvements applied." -ForegroundColor White
