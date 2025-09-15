# ============================================================================
# Azure Data Explorer to JSON Schema Export Script - SIMPLIFIED
# ============================================================================
# Simple script that makes two ADX REST API calls:
# 1. Get table list: .show tables | project TableName  
# 2. Get schema: TableName | getschema
# ============================================================================

# CONFIGURATION - UPDATE THESE VALUES FOR YOUR ENVIRONMENT
$adxClusterUri = "https://YOUR-CLUSTER-NAME.YOUR-REGION.kusto.windows.net"
$adxDatabase = "YOUR-DATABASE-NAME"
$outputDirectory = Join-Path $PSScriptRoot "json-exports-from-adx"
$ErrorActionPreference = "Stop"

# Import common module for token function
$modulePath = Join-Path $PSScriptRoot "LogAnalyticsCommon.psm1"
if (Test-Path $modulePath) { Import-Module $modulePath -Force }

Write-Host "ADX to JSON Export - Simplified Version" -ForegroundColor Cyan
Write-Host "Cluster: $adxClusterUri" -ForegroundColor Gray
Write-Host "Database: $adxDatabase" -ForegroundColor Gray

# Authenticate and get token
if (-not (Get-AzContext)) { Connect-AzAccount }
$token = Get-SafeAccessToken -ResourceUrl "https://kusto.kusto.windows.net/"
$headers = @{
    'Authorization' = "Bearer $token"
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

# Create output directory
if (-not (Test-Path $outputDirectory)) { 
    New-Item -Path $outputDirectory -ItemType Directory -Force | Out-Null 
}

function Convert-ADXTypeToJSONType {
    <#
    .SYNOPSIS
    Converts ADX data type to JSON export format (matching Log Analytics script)
    #>
    param([string]$adxType)
    
    switch ($adxType.ToLower()) {
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
        'decimal' { return 'Double' }
        default { 
            Write-Host "      Unknown ADX type '$adxType', mapping to 'String'" -ForegroundColor Yellow
            return 'String' 
        }
    }
}

function New-OrderedJSONSchema {
    <#
    .SYNOPSIS
    Creates ordered JSON schema following Microsoft conventions (like Log Analytics script)
    #>
    param([string]$tableName, [array]$columnDefinitions)
    
    # Filter out _TimeReceived column
    $filteredColumns = $columnDefinitions | Where-Object { $_.Name -ne "_TimeReceived" }
    
    # Sort columns following Microsoft's convention:
    # 1. TimeGenerated first
    # 2. Regular columns (alphabetical)
    # 3. Type column (if present) 
    # 4. Underscore columns (_ResourceId, etc.) - except _TimeReceived
    
    $timeGeneratedCol = $filteredColumns | Where-Object { $_.Name -eq "TimeGenerated" }
    $typeCol = $filteredColumns | Where-Object { $_.Name -eq "Type" }
    $underscoreCols = $filteredColumns | Where-Object { $_.Name -like "_*" -and $_.Name -ne "TimeGenerated" -and $_.Name -ne "Type" } | Sort-Object Name
    $regularCols = $filteredColumns | Where-Object { $_.Name -ne "TimeGenerated" -and $_.Name -ne "Type" -and $_.Name -notlike "_*" } | Sort-Object Name
    
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
            Name = $column.Name
            Type = Convert-ADXTypeToJSONType -adxType $column.Type
        }
    }
    
    # Create the JSON structure with Name FIRST (PowerShell hashtable order matters for JSON output)
    $jsonSchema = [ordered]@{
        Name = $tableName
        Properties = $jsonProperties
    }
    
    return $jsonSchema
}

# STEP 1: Get table list
Write-Host "`nGetting table list..." -ForegroundColor Yellow
$tablesQuery = @{
    "db" = $adxDatabase
    "csl" = ".show tables | project TableName"
} | ConvertTo-Json

try {
    $tablesResponse = Invoke-RestMethod -Uri "$adxClusterUri/v1/rest/mgmt" -Method Post -Headers $headers -Body $tablesQuery
    
    # Extract table names from the correct location in response
    $tableNames = @()
    
    # Handle Tables array structure
    if ($tablesResponse.Tables -and $tablesResponse.Tables.Count -gt 0) {
        $tableRows = $tablesResponse.Tables[0].Rows
        foreach ($tableName in $tableRows) {
            if (-not $tableName.StartsWith("_")) {  # Skip underscore tables
                $tableNames += $tableName
            }
        }
    }
    
    Write-Host "Found $($tableNames.Count) tables" -ForegroundColor Green
    if ($tableNames.Count -eq 0) {
        throw "No tables found after filtering"
    }
    
    # Show first few tables found
    $sampleTables = $tableNames | Select-Object -First 5
    Write-Host "Sample tables: $($sampleTables -join ', ')..." -ForegroundColor Gray
    
} catch {
    Write-Host "ERROR getting tables: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# STEP 2: Get schema for each table and create JSON
Write-Host "`nExporting schemas..." -ForegroundColor Yellow
$successCount = 0

foreach ($tableName in $tableNames) {
    try {
        Write-Host "Processing: $tableName" -ForegroundColor Cyan
        
        # Get schema
        $schemaQuery = @{
            "db" = $adxDatabase
            "csl" = "$tableName | getschema"
        } | ConvertTo-Json
        
        $schemaResponse = Invoke-RestMethod -Uri "$adxClusterUri/v2/rest/query" -Method Post -Headers $headers -Body $schemaQuery
        
        # Extract columns from response - schema uses FRAME structure
        $columns = @()
        
        # Look through all frames for the PrimaryResult
        foreach ($frame in $schemaResponse) {
            if ($frame.FrameType -eq "DataTable" -and $frame.TableKind -eq "PrimaryResult") {
                foreach ($row in $frame.Rows) {
                    # getschema returns: ColumnName, ColumnOrdinal, DataType, ColumnType
                    if ($row.Count -ge 4) {
                        $columns += @{
                            Name = $row[0]  # ColumnName
                            Type = $row[3]  # ColumnType
                        }
                    }
                }
                break  # Found the right frame, no need to continue
            }
        }
        
        if ($columns.Count -eq 0) {
            Write-Host "  WARNING: No columns found in PrimaryResult frame" -ForegroundColor Yellow
            continue
        }
        
        # Create ordered JSON schema with proper filtering and sorting
        $schema = New-OrderedJSONSchema -tableName $tableName -columnDefinitions $columns
        
        # Count filtered columns
        $originalCount = $columns.Count
        $filteredCount = $schema.Properties.Count
        $timeReceivedFiltered = if ($originalCount -ne $filteredCount) { " (filtered _TimeReceived)" } else { "" }
        
        # Save to file
        $jsonFile = Join-Path $outputDirectory "$tableName.json"
        $schema | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonFile -Encoding UTF8 -Force
        
        Write-Host "  SUCCESS: $originalCount -> $filteredCount columns$timeReceivedFiltered -> $tableName.json" -ForegroundColor Green
        $successCount++
        
    } catch {
        Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nCompleted: $successCount/$($tableNames.Count) tables exported" -ForegroundColor Magenta
Write-Host "Output directory: $outputDirectory" -ForegroundColor Gray
Write-Host "`nFeatures Applied:" -ForegroundColor Cyan
Write-Host "- Filtered out _TimeReceived column" -ForegroundColor White
Write-Host "- Microsoft column ordering (TimeGenerated first, Type last, underscore columns at end)" -ForegroundColor White
Write-Host "- Proper JSON type casing (String, DateTime, etc.)" -ForegroundColor White
Write-Host "- Correct JSON structure (Name first, Properties second)" -ForegroundColor White
Write-Host "- Compatible with json-to-* export scripts" -ForegroundColor White
