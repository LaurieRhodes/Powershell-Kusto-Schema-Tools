# Deploy Armis_Alerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Armis_Alerts_CL.parameters.json"
)

$deploymentName = "dcr-Armis_Alerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Armis_Alerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Armis_Alerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
