# ============================================================================
# JSON to Azure Data Explorer KQL Export Script
# ============================================================================
# Exports table schemas from JSON files as KQL scripts for Azure Data Explorer
# Uses standardized JSON exports from log-analytics-schema-export.ps1
#
# This script reads JSON schema files and generates KQL table creation scripts
# with the same structure as log-analytics-to-adx-kql-export.ps1 but from JSON sources
#
# Prerequisites: LogAnalyticsCommon.psm1 module in the same directory
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
# CONFIGURATION - UPDATE THESE VALUES
# ============================================================================

# Input/Output directories
$jsonExportDirectory = Join-Path $PSScriptRoot "json-exports"
$outputDirectory = $PSScriptRoot
$kqlDirectory = Join-Path $outputDirectory "kql-from-json"

# ADX Configuration
$rawTableRetention = "1d"
$rawTableCaching = "1h" 
$mainTableCaching = "1d"

# Processing settings
$ErrorActionPreference = "Stop"

# ============================================================================
# JSON-SPECIFIC FUNCTIONS
# ============================================================================

function Read-JSONSchema {
    <#
    .SYNOPSIS
    Reads table schema from JSON file
    
    .PARAMETER jsonFilePath
    Path to the JSON schema file
    #>
    param([string]$jsonFilePath)
    
    try {
        Write-Host "    Reading JSON schema from file..." -ForegroundColor Gray
        $jsonContent = Get-Content -Path $jsonFilePath -Raw -Encoding UTF8
        $schemaObject = $jsonContent | ConvertFrom-Json
        
        $columnDefinitions = @()
        
        # Handle Microsoft schema format: { "Name": "TableName", "Properties": [...] }
        if ($schemaObject.Properties) {
            foreach ($property in $schemaObject.Properties) {
                $columnDefinitions += @{
                    name = $property.Name
                    type = $property.Type
                    source = "JSONExport"
                }
            }
        }
        # Handle alternate format with direct properties array
        elseif ($schemaObject -is [array]) {
            foreach ($property in $schemaObject) {
                $columnDefinitions += @{
                    name = $property.name
                    type = $property.type
                    source = "JSONExport"
                }
            }
        }
        else {
            throw "Unrecognized JSON schema format"
        }
        
        $tableName = $schemaObject.Name
        if (-not $tableName) {
            # Extract table name from file name if not in JSON
            $tableName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFilePath)
        }
        
        Write-Host "    JSON Schema: Found $($columnDefinitions.Count) columns for $tableName" -ForegroundColor Gray
        return @{ 
            tableName = $tableName
            columns = $columnDefinitions
            tableType = "Custom"  # Assume custom tables for JSON exports
            success = $true 
        }
    } catch {
        Write-Host "    JSON Schema: ERROR - $($_.Exception.Message)" -ForegroundColor Yellow
        return @{ 
            tableName = ""
            columns = @()
            tableType = "Unknown"
            success = $false
            error = $_.Exception.Message 
        }
    }
}

function Generate-KQLScriptFromJSON {
    <#
    .SYNOPSIS
    Generates KQL script from JSON schema data
    
    .PARAMETER tableName
    Name of the table
    
    .PARAMETER columnDefinitions
    Array of column definitions from JSON
    
    .PARAMETER tableType
    Type of table (Custom for JSON exports)
    #>
    param([string]$tableName, [array]$columnDefinitions, [string]$tableType = "Custom")
    
    $rawTableName = "${tableName}Raw"
    $expandFunctionName = "${tableName}Expand"
    $mappingName = "${tableName}RawMapping"
    
    # Sort columns following Microsoft's convention:
    # 1. TimeGenerated first
    # 2. Regular columns (alphabetical)
    # 3. Type column (if present)
    # 4. Underscore columns (_ResourceId, etc.)
    # 5. _TimeReceived last (our addition)
    
    $timeGeneratedCol = $columnDefinitions | Where-Object { $_.name -eq "TimeGenerated" }
    $typeCol = $columnDefinitions | Where-Object { $_.name -eq "Type" }
    $underscoreCols = $columnDefinitions | Where-Object { $_.name -like "_*" } | Sort-Object name
    $regularCols = $columnDefinitions | Where-Object { $_.name -ne "TimeGenerated" -and $_.name -ne "Type" -and $_.name -notlike "_*" } | Sort-Object name
    
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
    
    $discoveryComment = "// Schema imported from JSON export file"
    $tableTypeComment = "// Table type: $tableType (presumed for JSON exports)"
    
    $kqlScript = @"
// ============================================================================
// Azure Data Explorer KQL Script for $tableName
// ============================================================================
// Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
$tableTypeComment
$discoveryComment
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
# MAIN EXECUTION
# ============================================================================

Write-Host "JSON to ADX KQL Export Script" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  JSON Directory: $jsonExportDirectory"
Write-Host "  Output Directory: $kqlDirectory"
Write-Host "  Processing: JSON schema exports from log-analytics-schema-export.ps1"

# Validate directories
if (-not (Test-Path $jsonExportDirectory)) {
    throw "ERROR: JSON export directory not found: $jsonExportDirectory"
}

if (-not (Test-Path $kqlDirectory)) { 
    New-Item -Path $kqlDirectory -ItemType Directory -Force | Out-Null 
    Write-Host "Created KQL output directory: $kqlDirectory" -ForegroundColor Green
}

# Get all JSON files
$jsonFiles = Get-ChildItem -Path $jsonExportDirectory -Filter "*.json" | Sort-Object Name
if ($jsonFiles.Count -eq 0) {
    throw "ERROR: No JSON files found in $jsonExportDirectory"
}

Write-Host "`nFound $($jsonFiles.Count) JSON schema files to process" -ForegroundColor Green

# Process each JSON file
Write-Host "`nGenerating KQL scripts from JSON schemas..." -ForegroundColor Yellow
$exportResults = @()
$successCount = 0
$failureCount = 0

foreach ($jsonFile in $jsonFiles) {
    try {
        Write-Host "Processing: $($jsonFile.Name)" -ForegroundColor Cyan
        
        # Read JSON schema
        $schemaResult = Read-JSONSchema -jsonFilePath $jsonFile.FullName
        
        if (-not $schemaResult.success) {
            throw $schemaResult.error
        }
        
        if ($schemaResult.columns.Count -eq 0) { 
            throw "No columns found in JSON schema" 
        }
        
        # Generate KQL script
        $kqlScript = Generate-KQLScriptFromJSON -tableName $schemaResult.tableName -columnDefinitions $schemaResult.columns -tableType $schemaResult.tableType
        
        # Save KQL file
        $kqlFile = Join-Path $kqlDirectory "$($schemaResult.tableName).kql"
        $kqlScript | Out-File -FilePath $kqlFile -Encoding UTF8 -Force
        
        Write-Host "  SUCCESS: $($schemaResult.columns.Count) columns -> $($schemaResult.tableName).kql" -ForegroundColor Green
        
        $exportResults += [PSCustomObject]@{
            TableName = $schemaResult.tableName
            ColumnCount = $schemaResult.columns.Count
            TableType = $schemaResult.tableType
            SourceFile = $jsonFile.Name
            KQLFile = "$($schemaResult.tableName).kql"
            Status = "Success"
        }
        $successCount++
        
    } catch {
        Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
        
        $tableName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFile.Name)
        $exportResults += [PSCustomObject]@{ 
            TableName = $tableName
            ColumnCount = 0
            SourceFile = $jsonFile.Name
            Status = "Failed"
            Error = $_.Exception.Message
        }
        $failureCount++
    }
}

# Summary
Write-Host "`nExport Summary:" -ForegroundColor Magenta
Write-Host "===============" -ForegroundColor Magenta
Write-Host "SUCCESS: $successCount/$($jsonFiles.Count) JSON files processed" -ForegroundColor Green
Write-Host "FAILED: $failureCount/$($jsonFiles.Count) JSON files failed" -ForegroundColor Red

if ($successCount -gt 0) {
    Write-Host "`nSuccessful Exports:" -ForegroundColor Green
    $exportResults | Where-Object { $_.Status -eq "Success" } | ForEach-Object {
        Write-Host "  * $($_.TableName): $($_.ColumnCount) columns -> $($_.KQLFile)" -ForegroundColor White
    }
}

if ($failureCount -gt 0) {
    Write-Host "`nFailed Exports:" -ForegroundColor Red
    $exportResults | Where-Object { $_.Status -eq "Failed" } | ForEach-Object {
        Write-Host "  * $($_.SourceFile): $($_.Error)" -ForegroundColor Red
    }
}

Write-Host "`nKQL Files Location:" -ForegroundColor Cyan
Write-Host "  Directory: $kqlDirectory" -ForegroundColor White
Write-Host "  Note: All tables are treated as custom tables with _TimeReceived field" -ForegroundColor White
Write-Host "  Note: Run generated .kql files in Azure Data Explorer to create tables" -ForegroundColor White

Write-Host "`nJSON to ADX KQL Export completed." -ForegroundColor White
