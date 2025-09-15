# Deploy OrcaAlerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-OrcaAlerts_CL.parameters.json"
)

$deploymentName = "dcr-OrcaAlerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying OrcaAlerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-OrcaAlerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
