# Deploy RedCanaryDetections_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-RedCanaryDetections_CL.parameters.json"
)

$deploymentName = "dcr-RedCanaryDetections_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying RedCanaryDetections_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-RedCanaryDetections_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
