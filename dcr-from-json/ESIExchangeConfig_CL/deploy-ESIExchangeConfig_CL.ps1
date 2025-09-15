# Deploy ESIExchangeConfig_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ESIExchangeConfig_CL.parameters.json"
)

$deploymentName = "dcr-ESIExchangeConfig_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ESIExchangeConfig_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ESIExchangeConfig_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
