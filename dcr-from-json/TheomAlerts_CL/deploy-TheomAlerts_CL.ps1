# Deploy TheomAlerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TheomAlerts_CL.parameters.json"
)

$deploymentName = "dcr-TheomAlerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TheomAlerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TheomAlerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
