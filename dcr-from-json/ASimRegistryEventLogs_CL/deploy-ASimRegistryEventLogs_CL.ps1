# Deploy ASimRegistryEventLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimRegistryEventLogs_CL.parameters.json"
)

$deploymentName = "dcr-ASimRegistryEventLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimRegistryEventLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimRegistryEventLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
