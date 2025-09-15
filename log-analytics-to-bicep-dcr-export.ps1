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

# Tables to export - alter to suit (excludes underscored tables automatically)
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
    'OktaV2_CL'
)

# Output directories
$outputDirectory = $PSScriptRoot
$dcrDirectory = Join-Path $outputDirectory "dcr"

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

function Generate-BicepDCR {
    param(
        [string]$tableName, 
        [array]$columnDefinitions, 
        [string]$tableType = "Unknown", 
        [bool]$isHybrid = $false
    )
    
    $filteredColumns = Filter-NonUnderscoreColumns -columns $columnDefinitions
    
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
    
    # CRITICAL FIX: Get correct output stream name based on table type
    $outputStreamName = Get-DCROutputStreamName -tableName $tableName -tableType $tableType
    Write-Host "    Output stream: $outputStreamName" -ForegroundColor Cyan
    
    $discoveryComment = if ($isHybrid) { "// Schema discovered using hybrid approach (Management API + getschema)" } else { "// Schema discovered using Management API only" }
    $tableTypeComment = "// Table type: $tableType"
    
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
    $template += "// Input columns: $($sortedColumns.Count) (JSON-compatible types only)`n"
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
Write-Host "  Tables to Export: $($tablesToExport.Count) tables"
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

# Show tables to export
Write-Host "`nTables to Export:" -ForegroundColor Cyan
$tablesToExport | ForEach-Object { Write-Host "  * $_" -ForegroundColor White }

# Export DCR templates
Write-Host "`nGenerating DCR files..." -ForegroundColor Yellow
$exportResults = @()
$successCount = 0
$failureCount = 0

foreach ($tableName in $tablesToExport) {
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
        
        $bicepTemplate = Generate-BicepDCR -tableName $tableName -columnDefinitions $finalColumns -tableType $tableType -isHybrid $useHybridDiscovery
        $savedFiles = Save-DCRFiles -tableName $tableName -bicepTemplate $bicepTemplate -columnDefinitions $finalColumns -tableType $tableType -isHybrid $useHybridDiscovery
        
        $mgmtCount = ($finalColumns | Where-Object { $_.source -eq "ManagementAPI" }).Count
        $schemaCount = $actualAdditionalCount
        
        Write-Host "  SUCCESS: $($finalColumns.Count) columns ($mgmtCount mgmt, $schemaCount additional) -> DCR files" -ForegroundColor Green
        
        $exportResults += [PSCustomObject]@{
            TableName = $tableName
            ColumnCount = $finalColumns.Count
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
Write-Host "SUCCESS: $successCount/$($tablesToExport.Count) tables exported" -ForegroundColor Green

if ($failureCount -gt 0) {
    Write-Host "FAILED: $failureCount tables failed" -ForegroundColor Red
}

if ($successCount -gt 0) {
    Write-Host "`nSuccessful Exports:" -ForegroundColor Green
    $exportResults | Where-Object { $_.Status -eq "Success" } | Sort-Object TableName | ForEach-Object {
        $additionalInfo = if ($_.GetSchemaCount -gt 0) { " (+$($_.GetSchemaCount) additional)" } else { "" }
        Write-Host "  * $($_.TableName): $($_.ColumnCount) columns$additionalInfo ($($_.TableType))" -ForegroundColor White
    }
}

if ($failureCount -gt 0) {
    Write-Host "`nFailed Exports:" -ForegroundColor Red
    $exportResults | Where-Object { $_.Status -eq "Failed" } | ForEach-Object {
        Write-Host "  * $($_.TableName): $($_.Error)" -ForegroundColor Red
    }
}

Write-Host "`nDCR files created in dcr\ directory with complete deployment packages." -ForegroundColor White
Write-Host "Update parameters files and run deployment scripts as needed." -ForegroundColor White
