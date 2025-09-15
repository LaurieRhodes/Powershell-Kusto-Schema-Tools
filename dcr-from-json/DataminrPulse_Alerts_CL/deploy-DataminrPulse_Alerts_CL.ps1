# Deploy DataminrPulse_Alerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-DataminrPulse_Alerts_CL.parameters.json"
)

$deploymentName = "dcr-DataminrPulse_Alerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying DataminrPulse_Alerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-DataminrPulse_Alerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
