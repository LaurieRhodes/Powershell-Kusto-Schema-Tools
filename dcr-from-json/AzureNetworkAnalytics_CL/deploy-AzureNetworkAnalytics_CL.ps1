# Deploy AzureNetworkAnalytics_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-AzureNetworkAnalytics_CL.parameters.json"
)

$deploymentName = "dcr-AzureNetworkAnalytics_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying AzureNetworkAnalytics_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-AzureNetworkAnalytics_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
