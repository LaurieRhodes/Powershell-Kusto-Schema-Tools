# Deploy ASimNetworkSessionLogs Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimNetworkSessionLogs.parameters.json"
)

$deploymentName = "dcr-ASimNetworkSessionLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimNetworkSessionLogs Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimNetworkSessionLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
