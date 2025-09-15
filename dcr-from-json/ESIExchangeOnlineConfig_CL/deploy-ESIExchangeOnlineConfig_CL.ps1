# Deploy ESIExchangeOnlineConfig_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ESIExchangeOnlineConfig_CL.parameters.json"
)

$deploymentName = "dcr-ESIExchangeOnlineConfig_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ESIExchangeOnlineConfig_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ESIExchangeOnlineConfig_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
