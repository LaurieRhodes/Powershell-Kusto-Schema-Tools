# Deploy VaronisAlerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-VaronisAlerts_CL.parameters.json"
)

$deploymentName = "dcr-VaronisAlerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying VaronisAlerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-VaronisAlerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
