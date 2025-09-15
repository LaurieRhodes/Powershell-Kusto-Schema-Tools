# Deploy darktrace_model_alerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-darktrace_model_alerts_CL.parameters.json"
)

$deploymentName = "dcr-darktrace_model_alerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying darktrace_model_alerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-darktrace_model_alerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
