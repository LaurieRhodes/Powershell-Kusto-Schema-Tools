# Deploy ExchangeHttpProxy_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ExchangeHttpProxy_CL.parameters.json"
)

$deploymentName = "dcr-ExchangeHttpProxy_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ExchangeHttpProxy_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ExchangeHttpProxy_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
