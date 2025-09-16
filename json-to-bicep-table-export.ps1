# ============================================================================
# JSON to Bicep Table Export Script - FIXED VERSION
# ============================================================================
# Exports table schemas from JSON files as Bicep table templates
# Uses standardized JSON exports from log-analytics-schema-export.ps1
#
# This script reads JSON schema files and generates Bicep table resources
# with the same structure as log-analytics-to-bicep-table-export.ps1 but from JSON sources
#
# Prerequisites: LogAnalyticsCommon.psm1 module in the same directory
# Usage: Update configuration below and run script
# ============================================================================

# Import common functions module
$modulePath = Join-Path $PSScriptRoot "LogAnalyticsCommon.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
} else {
    Write-Warning "LogAnalyticsCommon.psm1 module not found. Some functionality may be limited."
}

# ============================================================================
# CONFIGURATION - UPDATE THESE VALUES
# ============================================================================

# Input/Output directories
$jsonExportDirectory = Join-Path $PSScriptRoot "json-exports"
$outputDirectory = $PSScriptRoot
$bicepDirectory = Join-Path $outputDirectory "bicep-tables-from-json"

# Column filtering options
$FilterUnderscoreColumns = $false        # Set to $false to include underscore columns in table

# Bicep template configuration
$bicepConfig = @{
    WorkspaceSymbolicName = "logAnalyticsWorkspace"
    TablePlan = "Analytics"  # Analytics or Basic
    RetentionInDays = 30     # 4-730 days
    TotalRetentionInDays = 30 # 4-4383 days
    GenerateParameters = $true
}

# Processing settings
$ErrorActionPreference = "Stop"

# ============================================================================
# BICEP TABLE-SPECIFIC FUNCTIONS
# ============================================================================

function Convert-ToLogAnalyticsColumnType {
    param([string]$inputType)
    switch ($inputType.ToLower()) {
        'string' { return 'string' }
        'int' { return 'int' }
        'int32' { return 'int' }
        'int64' { return 'long' }
        'long' { return 'long' }
        'double' { return 'real' }
        'real' { return 'real' }
        'float' { return 'real' }
        'bool' { return 'boolean' }
        'boolean' { return 'boolean' }
        'datetime' { return 'dateTime' }
        'guid' { return 'guid' }
        'dynamic' { return 'dynamic' }
        default { return 'string' }
    }
}

function Get-ColumnDataTypeHint {
    param(
        [string]$columnName,
        [string]$columnType
    )
    
    $name = $columnName.ToLower()
    $type = $columnType.ToLower()
    
    # Guid hint (1) - only for actual guid types or specific guid-related columns
    if ($type -eq 'guid' -or ($type -eq 'string' -and $name -match '^(tenantid|workspaceid|subscriptionid|objectid|userid)$')) { 
        return 1  # Guid
    }
    
    # IP hint (3) - for string columns with IP-related names
    if ($type -eq 'string' -and $name -match 'ip$|ipaddr|ipaddress|sourceip|destip|clientip|serverip') { 
        return 3  # IP
    }
    
    # Uri hint (0) - for string columns with URL/URI-related names
    if ($type -eq 'string' -and $name -match 'url|uri|link|href') { 
        return 0  # Uri
    }
    
    # ArmPath hint (2) - for string columns with resource-related names
    if ($type -eq 'string' -and $name -match 'resourceid|_resourceid|resourcename|resourcepath|armpath') { 
        return 2  # ArmPath
    }
    
    return $null  # No hint
}

function Get-SanitizedTableName {
    param([string]$inputName)
    $name = [System.IO.Path]::GetFileNameWithoutExtension($inputName)
    $name = $name -replace '[^A-Za-z0-9_-]', '_'
    if ($name -notmatch '^[A-Za-z]') {
        $name = "Custom_$name"
    }
    if ($name.Length -lt 4) {
        $name = $name.PadRight(4, '_')
    } elseif ($name.Length -gt 63) {
        $name = $name.Substring(0, 60) + "_CL"
    }
    return $name
}

function Filter-ReservedColumns {
    param([array]$columns, [bool]$filterUnderscore)
    
    $reservedColumns = @('Type')  # Only Type is actually reserved for custom tables
    
    $filteredColumns = $columns | Where-Object { 
        $_.name -notin $reservedColumns -and
        (-not $filterUnderscore -or -not $_.name.StartsWith("_"))
    }
    
    $removedCount = $columns.Count - $filteredColumns.Count
    if ($removedCount -gt 0) {
        $removedColumns = $columns | Where-Object { 
            $_.name -in $reservedColumns -or ($filterUnderscore -and $_.name.StartsWith("_"))
        }
        Write-Host "    Filtered $removedCount columns: $($removedColumns.name -join ', ')" -ForegroundColor Yellow
    }
    
    return $filteredColumns
}

function New-BicepTableTemplate {
    param(
        [string]$tableName,
        [array]$columns,
        [string]$plan,
        [int]$retention,
        [int]$totalRetention,
        [bool]$filterUnderscore
    )
    
    $filteredColumns = Filter-ReservedColumns -columns $columns -filterUnderscore $filterUnderscore
    
    if ($filteredColumns.Count -eq 0) {
        throw "No valid columns remaining after filtering"
    }
    
    # Sort columns (TimeGenerated first, then alphabetical)
    $timeGeneratedCol = $filteredColumns | Where-Object { $_.name -eq "TimeGenerated" }
    $regularCols = $filteredColumns | Where-Object { $_.name -ne "TimeGenerated" } | Sort-Object name
    
    $sortedColumns = @()
    if ($timeGeneratedCol) { $sortedColumns += $timeGeneratedCol }
    $sortedColumns += $regularCols
    
    # Generate column definitions
    $columnsLines = @()
    $columnsLines += "      columns: ["
    
    for ($i = 0; $i -lt $sortedColumns.Count; $i++) {
        $column = $sortedColumns[$i]
        $columnsLines += "        {"
        
        $columnType = Convert-ToLogAnalyticsColumnType -inputType $column.type
        $dataTypeHint = Get-ColumnDataTypeHint -columnName $column.name -columnType $column.type
        
        $columnsLines += "          name: '$($column.name)'"
        $columnsLines += "          type: '$columnType'"
        
        if ($column.description) {
            $escapedDescription = $column.description -replace "'", "''"
            $columnsLines += "          description: '$escapedDescription'"
        }
        
        if ($column.displayName) {
            $escapedDisplayName = $column.displayName -replace "'", "''"
            $columnsLines += "          displayName: '$escapedDisplayName'"
        }
        
        if ($dataTypeHint -ne $null) {
            $columnsLines += "          dataTypeHint: $dataTypeHint"
        }
        
        $columnsLines += "        }"
    }
    
    $columnsLines += "      ]"
    $columnsString = $columnsLines -join "`r`n"
    
    $generatedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"
    $filterComment = if ($filterUnderscore) { "// Underscore columns filtered out" } else { "// Underscore columns included" }
    
    # Build template
    $template = @"
// Bicep template for Log Analytics custom table: $tableName
// Generated on $generatedDate
// Source: JSON schema export
// Original columns: $($columns.Count), Deployed columns: $($sortedColumns.Count) (Type column filtered)
$filterComment
// dataTypeHint values: 0=Uri, 1=Guid, 2=ArmPath, 3=IP

@description('Log Analytics Workspace name')
param workspaceName string

@description('Table plan - Analytics or Basic')
@allowed(['Analytics', 'Basic'])
param tablePlan string = '$plan'

@description('Data retention period in days')
@minValue(4)
@maxValue(730)
param retentionInDays int = $retention

@description('Total retention period in days')
@minValue(4)
@maxValue(4383)
param totalRetentionInDays int = $totalRetention

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: workspaceName
}

resource $($tableName.ToLower().Replace('_', ''))Table 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: '$tableName'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: '$tableName'
      description: 'Custom table $tableName - imported from JSON schema'
      displayName: '$tableName'
$columnsString
    }
  }
}

output tableName string = $($tableName.ToLower().Replace('_', ''))Table.name
output tableId string = $($tableName.ToLower().Replace('_', ''))Table.id
output provisioningState string = $($tableName.ToLower().Replace('_', ''))Table.properties.provisioningState
"@

    return $template
}

function New-ParametersJSONFile {
    param(
        [string]$tableName,
        [string]$plan,
        [int]$retention,
        [int]$totalRetention
    )
    
    $parametersContent = @"
{
  "`$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": { "value": "{workspace-name}" },
    "tablePlan": { "value": "$plan" },
    "retentionInDays": { "value": "$retention" },
    "totalRetentionInDays": { "value": "$totalRetention" }
  }
}
"@

    return $parametersContent
}

function Save-BicepTableFiles {
    param(
        [string]$tableName,
        [string]$bicepTemplate,
        [string]$plan,
        [int]$retention,
        [int]$totalRetention,
        [bool]$generateParameters
    )
    
    $tableDirectory = Join-Path $bicepDirectory $tableName
    if (-not (Test-Path $tableDirectory)) {
        New-Item -Path $tableDirectory -ItemType Directory -Force | Out-Null
    }
    
    # Save Bicep template
    $bicepFile = Join-Path $tableDirectory "$($tableName.ToLower())-table.bicep"
    $bicepTemplate | Out-File -FilePath $bicepFile -Encoding UTF8 -Force
    
    # Save parameters file if requested
    $parametersJSONFile = $null
    if ($generateParameters) {
        $parametersJSONContent = New-ParametersJSONFile -tableName $tableName -plan $plan -retention $retention -totalRetention $totalRetention
        $parametersJSONFile = Join-Path $tableDirectory "$($tableName.ToLower())-table.parameters.json"
        $parametersJSONContent | Out-File -FilePath $parametersJSONFile -Encoding UTF8 -Force
    }
    
    return @{
        bicepFile = $bicepFile
        parametersJSONFile = $parametersJSONFile
        directory = $tableDirectory
    }
}

function Read-JSONSchemaForTable {
    param([string]$jsonFilePath)
    
    try {
        $jsonContent = Get-Content -Path $jsonFilePath -Raw -Encoding UTF8
        $schemaObject = $jsonContent | ConvertFrom-Json
        
        $columnDefinitions = @()
        $tableName = ""
        
        # Handle standard format: { "Name": "TableName", "Properties": [...] }
        if ($schemaObject.Name -and $schemaObject.Properties) {
            $tableName = $schemaObject.Name
            foreach ($property in $schemaObject.Properties) {
                $columnDefinitions += @{
                    name = $property.name
                    type = $property.type
                    description = $property.description
                    displayName = $property.displayName
                }
            }
        }
        # Handle alternate format with direct columns array
        elseif ($schemaObject.columns) {
            $tableName = $schemaObject.name
            foreach ($column in $schemaObject.columns) {
                $columnDefinitions += @{
                    name = $column.name
                    type = $column.type
                    description = $column.description
                    displayName = $column.displayName
                }
            }
        }
        # Handle simple array format
        elseif ($schemaObject -is [array]) {
            $tableName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFilePath)
            foreach ($property in $schemaObject) {
                $columnDefinitions += @{
                    name = $property.name
                    type = $property.type
                    description = $property.description
                    displayName = $property.displayName
                }
            }
        }
        else {
            throw "Unrecognized JSON schema format"
        }
        
        if (-not $tableName) {
            $tableName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFilePath)
        }
        
        return @{ 
            tableName = $tableName
            columns = $columnDefinitions
            success = $true 
        }
    } catch {
        return @{ 
            tableName = ""
            columns = @()
            success = $false
            error = $_.Exception.Message 
        }
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-Host "JSON to Bicep Table Export Script - FIXED VERSION" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  JSON Directory: $jsonExportDirectory"
Write-Host "  Output Directory: $bicepDirectory"
Write-Host "  Filter Underscore Columns: $FilterUnderscoreColumns"
Write-Host "  Table Plan: $($bicepConfig.TablePlan)"
Write-Host "  Retention: $($bicepConfig.RetentionInDays) days"
Write-Host "  Generate Parameters: $($bicepConfig.GenerateParameters)"

# Validate input folder
if (-not (Test-Path $jsonExportDirectory)) {
    throw "ERROR: JSON input folder not found: $jsonExportDirectory"
}

# Create output folder if it doesn't exist
if (-not (Test-Path $bicepDirectory)) {
    New-Item -Path $bicepDirectory -ItemType Directory -Force | Out-Null
    Write-Host "Created output folder: $bicepDirectory" -ForegroundColor Green
}

# Get JSON files
$jsonFiles = Get-ChildItem -Path $jsonExportDirectory -Filter "*.json" -File | Sort-Object Name

if ($jsonFiles.Count -eq 0) {
    Write-Warning "No JSON files found in '$jsonExportDirectory'"
    return
}

Write-Host "`nProcessing $($jsonFiles.Count) JSON schema files..." -ForegroundColor Green

# Process each JSON file
$exportResults = @()
$successCount = 0
$failureCount = 0

foreach ($jsonFile in $jsonFiles) {
    try {
        Write-Host "Processing: $($jsonFile.Name)" -ForegroundColor Cyan
        
        # Read JSON schema
        $schemaResult = Read-JSONSchemaForTable -jsonFilePath $jsonFile.FullName
        
        if (-not $schemaResult.success) {
            throw $schemaResult.error
        }
        
        if ($schemaResult.columns.Count -eq 0) { 
            throw "No columns found in JSON schema" 
        }
        
        # Generate sanitized table name
        $sanitizedTableName = Get-SanitizedTableName $schemaResult.tableName
        
        # Generate Bicep table template
        $bicepTemplate = New-BicepTableTemplate -tableName $sanitizedTableName -columns $schemaResult.columns -plan $bicepConfig.TablePlan -retention $bicepConfig.RetentionInDays -totalRetention $bicepConfig.TotalRetentionInDays -filterUnderscore $FilterUnderscoreColumns
        
        # Calculate filtered column count for reporting
        $filteredColumns = Filter-ReservedColumns -columns $schemaResult.columns -filterUnderscore $FilterUnderscoreColumns
        
        # Save all table files
        $savedFiles = Save-BicepTableFiles -tableName $sanitizedTableName -bicepTemplate $bicepTemplate -plan $bicepConfig.TablePlan -retention $bicepConfig.RetentionInDays -totalRetention $bicepConfig.TotalRetentionInDays -generateParameters $bicepConfig.GenerateParameters
        
        Write-Host "  SUCCESS: $($filteredColumns.Count)/$($schemaResult.columns.Count) columns -> $($savedFiles.directory)" -ForegroundColor Green
        
        $exportResults += New-Object PSObject -Property @{
            SourceFile = $jsonFile.Name
            TableName = $sanitizedTableName
            OriginalColumnCount = $schemaResult.columns.Count
            DeployedColumnCount = $filteredColumns.Count
            Status = "Success"
            Directory = $savedFiles.directory
            BicepFile = $savedFiles.bicepFile
        }
        $successCount++
        
    } catch {
        Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
        
        $tableName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFile.Name)
        $exportResults += New-Object PSObject -Property @{ 
            SourceFile = $jsonFile.Name
            TableName = $tableName
            OriginalColumnCount = 0
            DeployedColumnCount = 0
            Status = "Failed"
            Error = $_.Exception.Message
            Directory = ""
        }
        $failureCount++
    }
}

# Summary
Write-Host "`nSummary: $successCount success, $failureCount failed" -ForegroundColor Magenta

if ($successCount -gt 0) {
    Write-Host "`nSuccessful exports:" -ForegroundColor Green
    $exportResults | Where-Object { $_.Status -eq "Success" } | ForEach-Object {
        Write-Host "  $($_.TableName): $($_.DeployedColumnCount) columns" -ForegroundColor White
    }
}

if ($failureCount -gt 0) {
    Write-Host "`nFailed exports:" -ForegroundColor Red
    $exportResults | Where-Object { $_.Status -eq "Failed" } | ForEach-Object {
        Write-Host "  $($_.SourceFile): $($_.Error)" -ForegroundColor Red
    }
}

Write-Host "`nFiles saved to: $bicepDirectory" -ForegroundColor Cyan
if ($FilterUnderscoreColumns) {
    Write-Host "Note: Type column and underscore columns were filtered out" -ForegroundColor Gray
} else {
    Write-Host "Note: Only Type column was filtered out" -ForegroundColor Gray
}

Write-Host "`nJSON to Bicep Table Export completed." -ForegroundColor White