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
    <#
    .SYNOPSIS
    Gets data type hint integer value for a column based on its name
    
    .DESCRIPTION
    Returns integer values for dataTypeHint based on Microsoft documentation:
    0 = Uri, 1 = Guid, 2 = ArmPath, 3 = IP
    
    .PARAMETER columnName
    Name of the column
    #>
    param([string]$columnName)
    
    $name = $columnName.ToLower()
    
    # Check for GUID patterns (dataTypeHint: 1)
    if ($name -match 'guid|tenantid|workspaceid|subscriptionid|objectid|userid$|_id$') { 
        return 1  # Guid
    }
    
    # Check for IP address patterns (dataTypeHint: 3)  
    if ($name -match 'ip$|ipaddr|ipaddress|sourceip|destip|clientip|serverip') { 
        return 3  # IP
    }
    
    # Check for URL patterns (dataTypeHint: 0)
    if ($name -match 'url|uri|link|href') { 
        return 0  # Uri
    }
    
    # Check for ARM resource path patterns (dataTypeHint: 2)
    if ($name -match 'resourceid|_resourceid|resourcename|resourcepath|armpath') { 
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
    <#
    .SYNOPSIS
    Filters out reserved columns that cannot be included in custom table schemas
    
    .DESCRIPTION
    Based on empirical testing, only 'Type' column is actually reserved.
    All other system columns like TenantId, _ResourceId, SourceSystem, etc. are allowed.
    
    .PARAMETER columns
    Array of column definitions
    #>
    param([array]$columns)
    
    # Based on testing: ONLY 'Type' is actually reserved for custom tables
    $reservedColumns = @(
        'Type'  # Confirmed reserved - deployment fails with this column
    )
    
    $filteredColumns = $columns | Where-Object { 
        $_.name -notin $reservedColumns
    }
    
    $removedCount = $columns.Count - $filteredColumns.Count
    if ($removedCount -gt 0) {
        Write-Host "    Filtered out $removedCount reserved column(s):" -ForegroundColor Yellow
        $removedColumns = $columns | Where-Object { 
            $_.name -in $reservedColumns
        }
        foreach ($col in $removedColumns) {
            Write-Host "      - $($col.name) (confirmed reserved)" -ForegroundColor Gray
        }
    }
    
    return $filteredColumns
}

function New-BicepTableTemplate {
    param(
        [string]$tableName,
        [array]$columns,
        [string]$workspaceName,
        [string]$plan,
        [int]$retention,
        [int]$totalRetention
    )
    
    # Filter out only the truly reserved columns (just 'Type')
    $filteredColumns = Filter-ReservedColumns -columns $columns
    
    if ($filteredColumns.Count -eq 0) {
        throw "No valid columns remaining after filtering out reserved columns"
    }
    
    # Sort columns following Microsoft's convention (TimeGenerated first, then alphabetical)
    $timeGeneratedCol = $filteredColumns | Where-Object { $_.name -eq "TimeGenerated" }
    $regularCols = $filteredColumns | Where-Object { $_.name -ne "TimeGenerated" } | Sort-Object name
    
    $sortedColumns = @()
    if ($timeGeneratedCol) { $sortedColumns += $timeGeneratedCol }
    $sortedColumns += $regularCols
    
    # Generate column definitions with proper comma handling
    $columnsLines = @()
    $columnsLines += "      columns: ["
    
    for ($i = 0; $i -lt $sortedColumns.Count; $i++) {
        $column = $sortedColumns[$i]
        
        # Start column object
        $columnsLines += "        {"
        
        # Column properties
        $columnType = Convert-ToLogAnalyticsColumnType -inputType $column.type
        $dataTypeHint = Get-ColumnDataTypeHint -columnName $column.name
        
        # Required properties
        $columnsLines += "          name: '$($column.name)'"
        $columnsLines += "          type: '$columnType'"
        
        # Optional properties
        if ($column.description) {
            $escapedDescription = $column.description -replace "'", "''"
            $columnsLines += "          description: '$escapedDescription'"
        }
        
        if ($column.displayName) {
            $escapedDisplayName = $column.displayName -replace "'", "''"
            $columnsLines += "          displayName: '$escapedDisplayName'"
        }
        
        # Add dataTypeHint as integer if applicable
        if ($dataTypeHint -ne $null) {
            $columnsLines += "          dataTypeHint: $dataTypeHint"
        }
        
        # Close column object - NO COMMA after closing brace
        $columnsLines += "        }"
    }
    
    $columnsLines += "      ]"
    $columnsString = $columnsLines -join "`r`n"
    
    $generatedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"
    
    # Build template
    $template = "// Bicep template for Log Analytics custom table: $tableName`r`n"
    $template += "// Generated on $generatedDate`r`n"
    $template += "// Source: JSON schema export`r`n"
    $template += "// Original columns: $($columns.Count), Deployed columns: $($sortedColumns.Count) (only 'Type' filtered out)`r`n"
    $template += "// dataTypeHint values: 0=Uri, 1=Guid, 2=ArmPath, 3=IP`r`n"
    $template += "`r`n"
    $template += "@description('Log Analytics Workspace name')`r`n"
    $template += "param workspaceName string`r`n"
    $template += "`r`n"
    $template += "@description('Table plan - Analytics or Basic')`r`n"
    $template += "@allowed(['Analytics', 'Basic'])`r`n"
    $template += "param tablePlan string = '$plan'`r`n"
    $template += "`r`n"
    $template += "@description('Data retention period in days')`r`n"
    $template += "@minValue(4)`r`n"
    $template += "@maxValue(730)`r`n"
    $template += "param retentionInDays int = $retention`r`n"
    $template += "`r`n"
    $template += "@description('Total retention period in days')`r`n"
    $template += "@minValue(4)`r`n"
    $template += "@maxValue(4383)`r`n"
    $template += "param totalRetentionInDays int = $totalRetention`r`n"
    $template += "`r`n"
    $template += "resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {`r`n"
    $template += "  name: workspaceName`r`n"
    $template += "}`r`n"
    $template += "`r`n"
    $template += "resource $($tableName.ToLower().Replace('_', ''))Table 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {`r`n"
    $template += "  parent: workspace`r`n"
    $template += "  name: '$tableName'`r`n"
    $template += "  properties: {`r`n"
    $template += "    plan: tablePlan`r`n"
    $template += "    retentionInDays: retentionInDays`r`n"
    $template += "    totalRetentionInDays: totalRetentionInDays`r`n"
    $template += "    schema: {`r`n"
    $template += "      name: '$tableName'`r`n"
    $template += "      description: 'Custom table $tableName - imported from JSON schema'`r`n"
    $template += "      displayName: '$tableName'`r`n"
    $template += "$columnsString`r`n"
    $template += "    }`r`n"
    $template += "  }`r`n"
    $template += "}`r`n"
    $template += "`r`n"
    $template += "output tableName string = $($tableName.ToLower().Replace('_', ''))Table.name`r`n"
    $template += "output tableId string = $($tableName.ToLower().Replace('_', ''))Table.id`r`n"
    $template += "output provisioningState string = $($tableName.ToLower().Replace('_', ''))Table.properties.provisioningState"

    return $template
}

function New-ParametersFile {
    param(
        [string]$tableName,
        [string]$workspaceName,
        [string]$plan,
        [int]$retention,
        [int]$totalRetention
    )
    
    $generatedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"
    
    $parametersTemplate = "// Parameters file for $tableName table deployment`r`n"
    $parametersTemplate += "// Generated on $generatedDate`r`n"
    $parametersTemplate += "`r`n"
    $parametersTemplate += "using './$($tableName.ToLower())-table.bicep'`r`n"
    $parametersTemplate += "`r`n"
    $parametersTemplate += "param workspaceName = '{workspace-name}'`r`n"
    $parametersTemplate += "param tablePlan = '$plan'`r`n"
    $parametersTemplate += "param retentionInDays = $retention`r`n"
    $parametersTemplate += "param totalRetentionInDays = $totalRetention"

    return $parametersTemplate
}

function Save-BicepTableFiles {
    param(
        [string]$tableName,
        [string]$bicepTemplate,
        [array]$columns,
        [string]$workspaceName,
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
    $parametersFile = $null
    if ($generateParameters) {
        $parametersContent = New-ParametersFile -tableName $tableName -workspaceName $workspaceName -plan $plan -retention $retention -totalRetention $totalRetention
        $parametersFile = Join-Path $tableDirectory "$($tableName.ToLower())-table.bicepparam"
        $parametersContent | Out-File -FilePath $parametersFile -Encoding UTF8 -Force
    }
    
    # Save deployment script
    $generatedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC"
    $deployScript = "# Deploy $tableName Log Analytics Table`r`n"
    $deployScript += "# Generated on $generatedDate`r`n"
    $deployScript += "`r`n"
    $deployScript += "param(`r`n"
    $deployScript += "    [Parameter(Mandatory=`$true)]`r`n"
    $deployScript += "    [string]`$ResourceGroupName,`r`n"
    $deployScript += "    `r`n"
    $deployScript += "    [Parameter(Mandatory=`$true)]`r`n"
    $deployScript += "    [string]`$WorkspaceName,`r`n"
    $deployScript += "    `r`n"
    $deployScript += "    [Parameter(Mandatory=`$false)]`r`n"
    $deployScript += "    [string]`$SubscriptionId = (Get-AzContext).Subscription.Id`r`n"
    $deployScript += ")`r`n"
    $deployScript += "`r`n"
    $deployScript += "`$deploymentName = `"$tableName-table-deployment-`$((Get-Date -Format 'yyyyMMdd-HHmmss'))`"`r`n"
    $deployScript += "`r`n"
    $deployScript += "Write-Host `"Deploying $tableName table to Log Analytics workspace...`" -ForegroundColor Cyan`r`n"
    $deployScript += "Write-Host `"  Workspace: `$WorkspaceName`" -ForegroundColor Gray`r`n"
    $deployScript += "Write-Host `"  Resource Group: `$ResourceGroupName`" -ForegroundColor Gray`r`n"
    $deployScript += "`r`n"
    $deployScript += "try {`r`n"
    $deployScript += "    `$deployment = New-AzResourceGroupDeployment ```r`n"
    $deployScript += "        -ResourceGroupName `$ResourceGroupName ```r`n"
    $deployScript += "        -Name `$deploymentName ```r`n"
    $deployScript += "        -TemplateFile `"$($tableName.ToLower())-table.bicep`" ```r`n"
    $deployScript += "        -workspaceName `$WorkspaceName ```r`n"
    $deployScript += "        -Verbose`r`n"
    $deployScript += "    `r`n"
    $deployScript += "    Write-Host `"SUCCESS: Table $tableName deployed successfully`" -ForegroundColor Green`r`n"
    $deployScript += "    Write-Host `"Table ID: `$(`$deployment.Outputs.tableId.Value)`" -ForegroundColor Gray`r`n"
    $deployScript += "    Write-Host `"Provisioning State: `$(`$deployment.Outputs.provisioningState.Value)`" -ForegroundColor Gray`r`n"
    $deployScript += "    `r`n"
    $deployScript += "} catch {`r`n"
    $deployScript += "    Write-Error `"Failed to deploy table $tableName`: `$(`$_.Exception.Message)`"`r`n"
    $deployScript += "    exit 1`r`n"
    $deployScript += "}"
    
    $deployFile = Join-Path $tableDirectory "deploy-$($tableName.ToLower()).ps1"
    $deployScript | Out-File -FilePath $deployFile -Encoding UTF8 -Force
    
    return @{
        bicepFile = $bicepFile
        parametersFile = $parametersFile
        deployFile = $deployFile
        directory = $tableDirectory
    }
}

function Read-JSONSchemaForTable {
    param([string]$jsonFilePath)
    
    try {
        Write-Host "    Reading JSON schema from file..." -ForegroundColor Gray
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
            # Extract table name from file name if not in JSON
            $tableName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFilePath)
        }
        
        Write-Host "    JSON Schema: Found $($columnDefinitions.Count) columns for $tableName" -ForegroundColor Gray
        return @{ 
            tableName = $tableName
            columns = $columnDefinitions
            success = $true 
        }
    } catch {
        Write-Host "    JSON Schema: ERROR - $($_.Exception.Message)" -ForegroundColor Yellow
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
Write-Host "Part of the ADX-to-LogAnalytics-Scanner toolkit" -ForegroundColor Gray
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor Gray

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  JSON Directory: $jsonExportDirectory"
Write-Host "  Output Directory: $bicepDirectory"
Write-Host "  Workspace Symbolic Name: $($bicepConfig.WorkspaceSymbolicName)"
Write-Host "  Table Plan: $($bicepConfig.TablePlan)"
Write-Host "  Retention: $($bicepConfig.RetentionInDays) days"
Write-Host "  Total Retention: $($bicepConfig.TotalRetentionInDays) days"
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

Write-Host "`nFound $($jsonFiles.Count) JSON schema file(s) to process" -ForegroundColor Green

# Process each JSON file
Write-Host "`nGenerating Bicep table resources..." -ForegroundColor Yellow
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
        Write-Host "  Table name: $sanitizedTableName" -ForegroundColor Gray
        Write-Host "  Original columns: $($schemaResult.columns.Count)" -ForegroundColor Gray
        
        # Generate Bicep table template (filtering happens inside the function)
        $bicepTemplate = New-BicepTableTemplate -tableName $sanitizedTableName -columns $schemaResult.columns -workspaceName $bicepConfig.WorkspaceSymbolicName -plan $bicepConfig.TablePlan -retention $bicepConfig.RetentionInDays -totalRetention $bicepConfig.TotalRetentionInDays
        
        # Calculate filtered column count for reporting
        $filteredColumns = Filter-ReservedColumns -columns $schemaResult.columns
        
        # Save all table files
        $savedFiles = Save-BicepTableFiles -tableName $sanitizedTableName -bicepTemplate $bicepTemplate -columns $schemaResult.columns -workspaceName $bicepConfig.WorkspaceSymbolicName -plan $bicepConfig.TablePlan -retention $bicepConfig.RetentionInDays -totalRetention $bicepConfig.TotalRetentionInDays -generateParameters $bicepConfig.GenerateParameters
        
        Write-Host "  SUCCESS: Generated Bicep table resource" -ForegroundColor Green
        Write-Host "    Deployed columns: $($filteredColumns.Count) (only 'Type' filtered out)" -ForegroundColor Gray
        Write-Host "    Files: $($savedFiles.directory)" -ForegroundColor Gray
        
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
Write-Host "`nExport Summary:" -ForegroundColor Magenta
Write-Host "===============" -ForegroundColor Magenta
Write-Host "SUCCESS: $successCount/$($jsonFiles.Count) JSON files processed" -ForegroundColor Green

if ($failureCount -gt 0) {
    Write-Host "FAILED: $failureCount/$($jsonFiles.Count) JSON files failed" -ForegroundColor Red
}

if ($successCount -gt 0) {
    Write-Host "`nSuccessful Exports:" -ForegroundColor Green
    $exportResults | Where-Object { $_.Status -eq "Success" } | ForEach-Object {
        Write-Host "  * $($_.TableName): $($_.DeployedColumnCount) columns (was $($_.OriginalColumnCount))" -ForegroundColor White
    }
}

if ($failureCount -gt 0) {
    Write-Host "`nFailed Exports:" -ForegroundColor Red
    $exportResults | Where-Object { $_.Status -eq "Failed" } | ForEach-Object {
        Write-Host "  * $($_.SourceFile): $($_.Error)" -ForegroundColor Red
    }
}

Write-Host "`nLessons Learned and Applied:" -ForegroundColor Cyan
Write-Host "- Only 'Type' column is actually reserved for custom tables" -ForegroundColor White
Write-Host "- All system columns (TenantId, _ResourceId, SourceSystem, etc.) are allowed" -ForegroundColor White
Write-Host "- dataTypeHint uses integers: 0=Uri, 1=Guid, 2=ArmPath, 3=IP" -ForegroundColor White
Write-Host "- Correct Bicep column array syntax with no trailing commas" -ForegroundColor White
Write-Host "- Tables use Microsoft.OperationalInsights/workspaces/tables@2025-02-01 resource" -ForegroundColor White

Write-Host "`nFiles Location:" -ForegroundColor Cyan
Write-Host "  Directory: $bicepDirectory" -ForegroundColor White
Write-Host "  Usage: Run deployment scripts with appropriate parameters" -ForegroundColor White

Write-Host "`nJSON to Bicep Table Export completed - FIXED VERSION with empirical lessons applied." -ForegroundColor White