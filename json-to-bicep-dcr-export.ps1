# ============================================================================
# JSON to Bicep DCR Export Script - FIXED VERSION
# ============================================================================
# Exports table schemas from JSON files as Bicep Data Collection Rule templates
# Uses standardized JSON exports from log-analytics-schema-export.ps1
#
# This script reads JSON schema files and generates complete DCR deployment packages
# with the same structure as log-analytics-to-bicep-dcr-export.ps1 but from JSON sources
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
$dcrDirectory = Join-Path $outputDirectory "dcr-from-json"

# Column filtering options
$FilterUnderscoreColumns = $true        # Set to $false to include underscore columns in DCR

# Bicep properties configuration
$bicepConfig = @{
    DefaultLocation = "Australia East"
    DefaultWorkspaceName = "sentinel-workspace"
    RoleDefinitionId = "3913510d-42f4-4e42-8a64-420c390055eb" # Monitoring Metrics Publisher
}

# Processing settings
$ErrorActionPreference = "Stop"

# ============================================================================
# DCR-SPECIFIC FUNCTIONS
# ============================================================================

function Filter-DCRReservedColumns {
    <#
    .SYNOPSIS
    Filters out reserved columns that cannot be included in DCR schemas
    
    .DESCRIPTION
    'Type' column is always filtered as it's reserved for DCRs and causes deployment failures.
    Underscore columns filtering is controlled by $FilterUnderscoreColumns variable.
    
    .PARAMETER columns
    Array of column definitions
    
    .PARAMETER filterUnderscore
    Whether to filter out underscore columns
    #>
    param([array]$columns, [bool]$filterUnderscore)
    
    # DCR reserved columns (always filtered - confirmed through testing)
    $dcrReservedColumns = @(
        'Type'  # Confirmed reserved for DCRs - deployment fails with this column
    )
    
    # Apply filtering based on parameters
    $filteredColumns = $columns | Where-Object { 
        # Always filter reserved columns
        $_.name -notin $dcrReservedColumns -and
        # Conditionally filter underscore columns
        (-not $filterUnderscore -or -not $_.name.StartsWith("_"))
    }
    
    $removedCount = $columns.Count - $filteredColumns.Count
    if ($removedCount -gt 0) {
        Write-Host "    Filtered out $removedCount columns for DCR:" -ForegroundColor Yellow
        $removedColumns = $columns | Where-Object { 
            $_.name -in $dcrReservedColumns -or ($filterUnderscore -and $_.name.StartsWith("_"))
        }
        foreach ($col in $removedColumns) {
            if ($col.name -in $dcrReservedColumns) {
                Write-Host "      - $($col.name) (reserved for DCR)" -ForegroundColor Gray
            } else {
                Write-Host "      - $($col.name) (underscore column)" -ForegroundColor Gray
            }
        }
    }
    
    return $filteredColumns
}

function Read-JSONSchemaForDCR {
    <#
    .SYNOPSIS
    Reads table schema from JSON file for DCR processing
    
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
            tableType = "Custom"  # Assume custom tables for JSON exports (per requirements)
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

function Generate-BicepDCRFromJSON {
    <#
    .SYNOPSIS
    Generates Bicep DCR template from JSON schema data
    
    .PARAMETER tableName
    Name of the table
    
    .PARAMETER columnDefinitions
    Array of column definitions from JSON
    
    .PARAMETER tableType
    Type of table (Custom for JSON exports)
    
    .PARAMETER filterUnderscore
    Whether to filter underscore columns
    #>
    param(
        [string]$tableName, 
        [array]$columnDefinitions, 
        [string]$tableType = "Custom",
        [bool]$filterUnderscore
    )
    
    # Filter out reserved columns for DCR (Type always filtered, underscore based on parameter)
    $filteredColumns = Filter-DCRReservedColumns -columns $columnDefinitions -filterUnderscore $filterUnderscore
    
    # Sort columns following Microsoft's convention
    $timeGeneratedCol = $filteredColumns | Where-Object { $_.name -eq "TimeGenerated" }
    $regularCols = $filteredColumns | Where-Object { $_.name -ne "TimeGenerated" } | Sort-Object name
    
    $sortedColumns = @()
    if ($timeGeneratedCol) { $sortedColumns += $timeGeneratedCol }
    $sortedColumns += $regularCols
    
    # Generate columns and transforms
    $bicepColumns = @()
    $transformProjectColumns = @()
    
    Write-Host "    Generating DCR schema (JSON input types only)..." -ForegroundColor Gray
    
    foreach ($column in $sortedColumns) {
        $inputType = ConvertTo-DCRInputType -logAnalyticsType $column.type
        $outputType = $column.type
        
        # Create column definition
        $columnText = "          {`n            name: '$($column.name)'`n            type: '$inputType'`n          }"
        $bicepColumns += $columnText
        
        # Create transform
        $transformFunc = Get-DCRTransformFunction -columnName $column.name -inputType $inputType -outputType $outputType
        $transformProjectColumns += $transformFunc
        
        # Log conversion details for complex types
        if ($inputType -ne $outputType) {
            Write-Host "      $($column.name): $inputType -> $outputType (via $transformFunc)" -ForegroundColor Cyan
        }
    }
    
    $bicepColumnsText = $bicepColumns -join "`n"
    $transformProjectText = $transformProjectColumns -join ", "
    
    # For JSON exports, always use Custom- output stream as per requirements
    $outputStreamName = "Custom-$tableName"
    Write-Host "    Output stream: $outputStreamName (custom table as specified)" -ForegroundColor Cyan
    
    $discoveryComment = "// Schema imported from JSON export file"
    $tableTypeComment = "// Table type: $tableType (presumed custom for JSON exports)"
    $filterComment = if ($filterUnderscore) { "// Underscore columns filtered out" } else { "// Underscore columns included" }
    
    # Build template using string concatenation to avoid here-string issues
    $template = "@description('The location of the resources')`n"
    $template += "param location string = '$($bicepConfig.DefaultLocation)'`n"
    $template += "@description('The name of the Data Collection Endpoint Id')`n"
    $template += "param dataCollectionEndpointId string`n"
    $template += "@description('The Log Analytics Workspace Id used for Sentinel')`n"
    $template += "param workspaceResourceId string`n"
    $template += "@description('The Target Sentinel workspace name')`n"
    $template += "param workspaceName string = '$($bicepConfig.DefaultWorkspaceName)'`n"
    $template += "@description('The Service Principal Object ID of the Entra App')`n"
    $template += "param servicePrincipalObjectId string`n`n"
    
    $template += "// ============================================================================`n"
    $template += "// Data Collection Rule for $tableName`n"
    $template += "// ============================================================================`n"
    $template += "// Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
    $template += "$tableTypeComment`n"
    $template += "$discoveryComment`n"
    $template += "$filterComment`n"
    $template += "// Original columns: $($columnDefinitions.Count), DCR columns: $($sortedColumns.Count) (Type column always filtered)`n"
    $template += "// Output stream: $outputStreamName`n"
    $template += "// Note: Input stream uses string/dynamic only. Type conversions in transform.`n"
    $template += "// ============================================================================`n`n"
    
    $template += "var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '$($bicepConfig.RoleDefinitionId)')`n`n"
    
    $template += "resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {`n"
    $template += "  name: 'dcr-`${workspaceName}-$tableName'`n"
    $template += "  location: location`n"
    $template += "  properties: {`n"
    $template += "    dataCollectionEndpointId: dataCollectionEndpointId`n"
    $template += "    streamDeclarations: {`n"
    $template += "      'Custom-$tableName': {`n"
    $template += "        columns: [`n"
    $template += "$bicepColumnsText`n"
    $template += "        ]`n"
    $template += "      }`n"
    $template += "    }`n"
    $template += "    dataSources: {}`n"
    $template += "    destinations: {`n"
    $template += "      logAnalytics: [`n"
    $template += "        {`n"
    $template += "          workspaceResourceId: workspaceResourceId`n"
    $template += "          name: 'Sentinel-$tableName'`n"
    $template += "        }`n"
    $template += "      ]`n"
    $template += "    }`n"
    $template += "    dataFlows: [`n"
    $template += "      {`n"
    $template += "        streams: ['Custom-$tableName']`n"
    $template += "        destinations: ['Sentinel-$tableName']`n"
    $template += "        transformKql: 'source | project $transformProjectText'`n"
    $template += "        outputStream: '$outputStreamName'`n"
    $template += "      }`n"
    $template += "    ]`n"
    $template += "  }`n"
    $template += "}`n`n"
    
    $template += "// Role Assignment to the DCR`n"
    $template += "resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {`n"
    $template += "  scope: dataCollectionRule`n"
    $template += "  name: guid(resourceGroup().id, roleDefinitionResourceId, dataCollectionRule.name)`n"
    $template += "  properties: {`n"
    $template += "    roleDefinitionId: roleDefinitionResourceId`n"
    $template += "    principalId: servicePrincipalObjectId`n"
    $template += "    principalType: 'ServicePrincipal'`n"
    $template += "  }`n"
    $template += "}`n`n"
    
    $template += "output immutableId string = dataCollectionRule.properties.immutableId`n"
    $template += "output dataCollectionRuleId string = dataCollectionRule.id`n"
    $template += "output dataCollectionRuleName string = dataCollectionRule.name"
    
    return $template
}

function Save-DCRFilesFromJSON {
    <#
    .SYNOPSIS
    Saves DCR deployment files for JSON-based schema
    
    .PARAMETER tableName
    Name of the table
    
    .PARAMETER bicepTemplate
    Bicep template content
    
    .PARAMETER columnDefinitions
    Array of column definitions
    
    .PARAMETER tableType
    Type of table
    #>
    param(
        [string]$tableName, 
        [string]$bicepTemplate, 
        [array]$columnDefinitions, 
        [string]$tableType
    )
    
    $tableDirectory = Join-Path $dcrDirectory $tableName
    if (-not (Test-Path $tableDirectory)) {
        New-Item -Path $tableDirectory -ItemType Directory -Force | Out-Null
    }
    
    # Save Bicep template
    $bicepFile = Join-Path $tableDirectory "dcr-$tableName.bicep"
    $bicepTemplate | Out-File -FilePath $bicepFile -Encoding UTF8 -Force
    
    # Save parameters file
    $parametersContent = "{`n"
    $parametersContent += "  `"`$schema`": `"https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#`",`n"
    $parametersContent += "  `"contentVersion`": `"1.0.0.0`",`n"
    $parametersContent += "  `"parameters`": {`n"
    $parametersContent += "    `"location`": { `"value`": `"$($bicepConfig.DefaultLocation)`" },`n"
    $parametersContent += "    `"dataCollectionEndpointId`": { `"value`": `"/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Insights/dataCollectionEndpoints/{dce-name}`" },`n"
    $parametersContent += "    `"workspaceResourceId`": { `"value`": `"/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.OperationalInsights/workspaces/{workspace-name}`" },`n"
    $parametersContent += "    `"workspaceName`": { `"value`": `"$($bicepConfig.DefaultWorkspaceName)`" },`n"
    $parametersContent += "    `"servicePrincipalObjectId`": { `"value`": `"{service-principal-object-id}`" }`n"
    $parametersContent += "  }`n"
    $parametersContent += "}"
    
    $parametersFile = Join-Path $tableDirectory "dcr-$tableName.parameters.json"
    $parametersContent | Out-File -FilePath $parametersFile -Encoding UTF8 -Force
    
    # Save PowerShell deployment script
    $psDeployScript = "# Deploy $tableName Data Collection Rule (from JSON export)`n"
    $psDeployScript += "param(`n"
    $psDeployScript += "    [Parameter(Mandatory=`$true)]`n"
    $psDeployScript += "    [string]`$ResourceGroupName,`n`n"
    $psDeployScript += "    [Parameter(Mandatory=`$false)]`n"
    $psDeployScript += "    [string]`$ParametersFile = `"dcr-$tableName.parameters.json`"`n"
    $psDeployScript += ")`n`n"
    $psDeployScript += "`$deploymentName = `"dcr-$tableName-deployment-`$(Get-Date -Format 'yyyyMMdd-HHmmss')`"`n`n"
    $psDeployScript += "Write-Host `"Deploying $tableName Data Collection Rule (from JSON export)...`" -ForegroundColor Cyan`n`n"
    $psDeployScript += "New-AzResourceGroupDeployment ```n"
    $psDeployScript += "    -ResourceGroupName `$ResourceGroupName ```n"
    $psDeployScript += "    -Name `$deploymentName ```n"
    $psDeployScript += "    -TemplateFile `"dcr-$tableName.bicep`" ```n"
    $psDeployScript += "    -TemplateParameterFile `$ParametersFile ```n"
    $psDeployScript += "    -Verbose"
    
    $psDeployFile = Join-Path $tableDirectory "deploy-$tableName.ps1"
    $psDeployScript | Out-File -FilePath $psDeployFile -Encoding UTF8 -Force
    
    return @{
        bicepFile = $bicepFile
        parametersFile = $parametersFile
        deployFile = $psDeployFile
        directory = $tableDirectory
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-Host "JSON to Bicep DCR Export Script - FIXED VERSION" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  JSON Directory: $jsonExportDirectory"
Write-Host "  Output Directory: $dcrDirectory"
Write-Host "  Filter Underscore Columns: $FilterUnderscoreColumns"
Write-Host "  Processing: JSON schema exports with corrected data types"
Write-Host "  Table Type: All tables treated as custom (per requirements)"
Write-Host "  DCR Approach: JSON-compatible input types with KQL transforms"
Write-Host "  Reserved Columns: Type column always filtered out for DCRs"

# Validate directories
if (-not (Test-Path $jsonExportDirectory)) {
    throw "ERROR: JSON export directory not found: $jsonExportDirectory"
}

if (-not (Test-Path $dcrDirectory)) { 
    New-Item -Path $dcrDirectory -ItemType Directory -Force | Out-Null 
    Write-Host "Created DCR output directory: $dcrDirectory" -ForegroundColor Green
}

# Get all JSON files
$jsonFiles = Get-ChildItem -Path $jsonExportDirectory -Filter "*.json" | Sort-Object Name
if ($jsonFiles.Count -eq 0) {
    throw "ERROR: No JSON files found in $jsonExportDirectory"
}

Write-Host "`nFound $($jsonFiles.Count) JSON schema files to process" -ForegroundColor Green

# Process each JSON file
Write-Host "`nGenerating DCR files from JSON schemas..." -ForegroundColor Yellow
$exportResults = @()
$successCount = 0
$failureCount = 0

foreach ($jsonFile in $jsonFiles) {
    try {
        Write-Host "Processing: $($jsonFile.Name)" -ForegroundColor Cyan
        
        # Read JSON schema
        $schemaResult = Read-JSONSchemaForDCR -jsonFilePath $jsonFile.FullName
        
        if (-not $schemaResult.success) {
            throw $schemaResult.error
        }
        
        if ($schemaResult.columns.Count -eq 0) { 
            throw "No columns found in JSON schema" 
        }
        
        # Generate Bicep DCR template
        $bicepTemplate = Generate-BicepDCRFromJSON -tableName $schemaResult.tableName -columnDefinitions $schemaResult.columns -tableType $schemaResult.tableType -filterUnderscore $FilterUnderscoreColumns
        
        # Save all DCR files
        $savedFiles = Save-DCRFilesFromJSON -tableName $schemaResult.tableName -bicepTemplate $bicepTemplate -columnDefinitions $schemaResult.columns -tableType $schemaResult.tableType
        
        # Filter columns for DCR count
        $filteredColumns = Filter-DCRReservedColumns -columns $schemaResult.columns -filterUnderscore $FilterUnderscoreColumns
        $filteredCount = $filteredColumns.Count
        
        # Show output stream info
        $outputStreamName = "Custom-$($schemaResult.tableName)"
        
        Write-Host "  SUCCESS: $($schemaResult.columns.Count) total columns -> $filteredCount DCR columns" -ForegroundColor Green
        Write-Host "    Output Stream: $outputStreamName" -ForegroundColor Gray
        Write-Host "    Files: $($savedFiles.directory)" -ForegroundColor Gray
        
        $exportResults += [PSCustomObject]@{
            TableName = $schemaResult.tableName
            TotalColumns = $schemaResult.columns.Count
            DCRColumns = $filteredCount
            TableType = $schemaResult.tableType
            OutputStream = $outputStreamName
            SourceFile = $jsonFile.Name
            Status = "Success"
            Directory = $savedFiles.directory
        }
        $successCount++
        
    } catch {
        Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
        
        $tableName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFile.Name)
        $exportResults += [PSCustomObject]@{ 
            TableName = $tableName
            TotalColumns = 0
            DCRColumns = 0
            SourceFile = $jsonFile.Name
            Status = "Failed"
            Error = $_.Exception.Message
            Directory = ""
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
        Write-Host "  * $($_.TableName): $($_.DCRColumns) DCR columns ($($_.TableType)) -> $($_.OutputStream)" -ForegroundColor White
    }
}

if ($failureCount -gt 0) {
    Write-Host "`nFailed Exports:" -ForegroundColor Red
    $exportResults | Where-Object { $_.Status -eq "Failed" } | ForEach-Object {
        Write-Host "  * $($_.SourceFile): $($_.Error)" -ForegroundColor Red
    }
}

Write-Host "`nDCR Design Summary:" -ForegroundColor Cyan
Write-Host "- Input streams use JSON-compatible types only (string/dynamic)" -ForegroundColor White
Write-Host "- Type conversions handled in KQL transform layer" -ForegroundColor White
Write-Host "- Type column always filtered out (reserved for DCRs)" -ForegroundColor White
if ($FilterUnderscoreColumns) {
    Write-Host "- Underscore columns filtered out" -ForegroundColor White
} else {
    Write-Host "- Underscore columns included in DCR" -ForegroundColor White
}
Write-Host "- All tables treated as custom tables (Custom-TableName output streams)" -ForegroundColor White
Write-Host "- Each table directory contains complete deployment package" -ForegroundColor White
Write-Host "- Defensive casting ensures resilience against operator errors" -ForegroundColor White
Write-Host "- Schema source: JSON exports with corrected data types" -ForegroundColor White

Write-Host "`nFiles Location:" -ForegroundColor Cyan
Write-Host "  Directory: $dcrDirectory" -ForegroundColor White
Write-Host "  Structure: Each table has its own subdirectory with complete deployment files" -ForegroundColor White
Write-Host "  Usage: Update parameters files and run deployment scripts as needed" -ForegroundColor White

Write-Host "`nJSON to Bicep DCR Export completed - Type column filtering applied." -ForegroundColor White
