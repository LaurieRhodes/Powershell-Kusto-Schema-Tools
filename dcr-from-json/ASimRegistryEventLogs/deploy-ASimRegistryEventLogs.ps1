# Deploy ASimRegistryEventLogs Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimRegistryEventLogs.parameters.json"
)

$deploymentName = "dcr-ASimRegistryEventLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimRegistryEventLogs Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimRegistryEventLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
