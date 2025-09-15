# Deploy GCP_MONITORING_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-GCP_MONITORING_CL.parameters.json"
)

$deploymentName = "dcr-GCP_MONITORING_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying GCP_MONITORING_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-GCP_MONITORING_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
