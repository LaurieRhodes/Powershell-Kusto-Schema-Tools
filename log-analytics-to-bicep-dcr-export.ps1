# ============================================================================
# Log Analytics to Bicep DCR Export Script (COMPLETE VERSION WITH FIXED OUTPUT STREAMS)
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
$ExportAll = $false                    # Set to $true to export ALL workspace tables

# Column filtering options
$FilterUnderscoreColumns = $false     # Set to $false to include underscore columns in DCR

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
$dcrDirectory = Join-Path $outputDirectory "dcr-from-log-analytics"

# Bicep template configuration
$bicepConfig = @{
    DefaultLocation = "Australia East"
    DefaultWorkspaceName = "sentinel-workspace"
    RoleDefinitionId = "3913510d-42f4-4e42-8a64-420c390055eb" # Monitoring Metrics Publisher
}

# Hybrid discovery settings
$useHybridDiscovery = $true
$preferManagementAPITypes = $true
$ErrorActionPreference = "Stop"

# ============================================================================
# FUNCTIONS
# ============================================================================

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

function Generate-BicepDCR {
    param(
        [string]$tableName, 
        [array]$columnDefinitions, 
        [string]$tableType = "Unknown", 
        [bool]$isHybrid = $false,
        [bool]$filterUnderscore = $false
    )
    
    # Filter out reserved columns for DCR (Type always filtered, underscore based on parameter)
    $filteredColumns = Filter-DCRReservedColumns -columns $columnDefinitions -filterUnderscore $filterUnderscore
    
    # Sort columns following Microsoft's convention
    $timeGeneratedCol = $filteredColumns | Where-Object { $_.name -eq "TimeGenerated" }
    $typeCol = $filteredColumns | Where-Object { $_.name -eq "Type" }
    $regularCols = $filteredColumns | Where-Object { $_.name -ne "TimeGenerated" -and $_.name -ne "Type" } | Sort-Object name
    
    $sortedColumns = @()
    if ($timeGeneratedCol) { $sortedColumns += $timeGeneratedCol }
    $sortedColumns += $regularCols
    if ($typeCol) { $sortedColumns += $typeCol }
    
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
    
    # CRITICAL FIX: Get correct output stream name and input stream name based on table type
    $outputStreamName = Get-DCROutputStreamName -tableName $tableName -tableType $tableType
    $inputStreamName = "Custom-$tableName"  # Input streams are always Custom- regardless of table type
    Write-Host "    Input stream: $inputStreamName -> Output stream: $outputStreamName" -ForegroundColor Cyan
    
    $discoveryComment = if ($isHybrid) { "// Schema discovered using hybrid approach (Management API + getschema)" } else { "// Schema discovered using Management API only" }
    $tableTypeComment = "// Table type: $tableType"
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
    $template += "// Input stream: $inputStreamName (always Custom- for JSON ingestion)`n"
    $template += "// Output stream: $outputStreamName (based on table type)`n"
    $template += "// Note: Input stream uses string/dynamic only. Type conversions in transform.`n"
    $template += "// ============================================================================`n`n"
    
    $template += "var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '$($bicepConfig.RoleDefinitionId)')`n`n"
    
    $template += "resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {`n"
    $template += "  name: 'dcr-`${workspaceName}-$tableName'`n"
    $template += "  location: location`n"
    $template += "  properties: {`n"
    $template += "    dataCollectionEndpointId: dataCollectionEndpointId`n"
    $template += "    streamDeclarations: {`n"
    $template += "      '$inputStreamName': {`n"
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
    $template += "        streams: ['$inputStreamName']`n"
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

function Save-DCRFiles {
    param(
        [string]$tableName, 
        [string]$bicepTemplate, 
        [array]$columnDefinitions, 
        [string]$tableType, 
        [bool]$isHybrid
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
    $psDeployScript = "# Deploy $tableName Data Collection Rule`n"
    $psDeployScript += "param(`n"
    $psDeployScript += "    [Parameter(Mandatory=`$true)]`n"
    $psDeployScript += "    [string]`$ResourceGroupName,`n`n"
    $psDeployScript += "    [Parameter(Mandatory=`$false)]`n"
    $psDeployScript += "    [string]`$ParametersFile = `"dcr-$tableName.parameters.json`"`n"
    $psDeployScript += ")`n`n"
    $psDeployScript += "`$deploymentName = `"dcr-$tableName-deployment-`$(Get-Date -Format 'yyyyMMdd-HHmmss')`"`n`n"
    $psDeployScript += "Write-Host `"Deploying $tableName Data Collection Rule...`" -ForegroundColor Cyan`n`n"
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

Write-Host "Log Analytics to Bicep DCR Export Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  Workspace: $workspaceName"
Write-Host "  Resource Group: $resourceGroupName"
Write-Host "  Subscription: $subscriptionId"
Write-Host "  Export All Tables: $ExportAll"
Write-Host "  Filter Underscore Columns: $FilterUnderscoreColumns"
Write-Host "  Output Directory: $dcrDirectory"
Write-Host "  Hybrid Discovery: $useHybridDiscovery"

# Validate and prepare
if (-not $workspaceName -or -not $resourceGroupName -or -not $subscriptionId) {
    throw "ERROR: Configuration values cannot be empty"
}

if (-not (Test-Path $dcrDirectory)) { 
    New-Item -Path $dcrDirectory -ItemType Directory -Force | Out-Null 
    Write-Host "Created DCR directory: $dcrDirectory" -ForegroundColor Green
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

# Export DCR templates
Write-Host "`nGenerating DCR files..." -ForegroundColor Yellow
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
        
        $bicepTemplate = Generate-BicepDCR -tableName $tableName -columnDefinitions $finalColumns -tableType $tableType -isHybrid $useHybridDiscovery -filterUnderscore $FilterUnderscoreColumns
        $savedFiles = Save-DCRFiles -tableName $tableName -bicepTemplate $bicepTemplate -columnDefinitions $finalColumns -tableType $tableType -isHybrid $useHybridDiscovery
        
        # Calculate filtered column count for reporting
        $filteredColumns = Filter-DCRReservedColumns -columns $finalColumns -filterUnderscore $FilterUnderscoreColumns
        
        $mgmtCount = ($finalColumns | Where-Object { $_.source -eq "ManagementAPI" }).Count
        $schemaCount = $actualAdditionalCount
        
        Write-Host "  SUCCESS: $($finalColumns.Count) total columns -> $($filteredColumns.Count) DCR columns" -ForegroundColor Green
        
        $exportResults += [PSCustomObject]@{
            TableName = $tableName
            ColumnCount = $finalColumns.Count
            DCRColumns = $filteredColumns.Count
            ManagementAPICount = $mgmtCount
            GetSchemaCount = $schemaCount
            TableType = $tableType
            Status = "Success"
            DiscoveryMethod = $discoveryMethod
            Directory = $savedFiles.directory
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

if ($successCount -gt 0) {
    Write-Host "`nSuccessful Exports:" -ForegroundColor Green
    $exportResults | Where-Object { $_.Status -eq "Success" } | Sort-Object TableName | ForEach-Object {
        $additionalInfo = if ($_.GetSchemaCount -gt 0) { " (+$($_.GetSchemaCount) additional)" } else { "" }
        Write-Host "  * $($_.TableName): $($_.DCRColumns) DCR columns (was $($_.ColumnCount))$additionalInfo ($($_.TableType))" -ForegroundColor White
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

Write-Host "`nDCR Design Summary:" -ForegroundColor Cyan
Write-Host "- Input streams use JSON-compatible types only (string/dynamic)" -ForegroundColor White
Write-Host "- Type conversions handled in KQL transform layer" -ForegroundColor White
Write-Host "- Type column always filtered out (reserved for DCRs)" -ForegroundColor White
if ($FilterUnderscoreColumns) {
    Write-Host "- Underscore columns filtered out" -ForegroundColor White
} else {
    Write-Host "- Underscore columns included in DCR" -ForegroundColor White
}

Write-Host "`nDCR files created in dcr\ directory with complete deployment packages." -ForegroundColor White
Write-Host "Update parameters files and run deployment scripts as needed." -ForegroundColor White