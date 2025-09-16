# Deploy Anomalies Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Anomalies.parameters.json"
)

$deploymentName = "dcr-Anomalies-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Anomalies Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Anomalies.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
