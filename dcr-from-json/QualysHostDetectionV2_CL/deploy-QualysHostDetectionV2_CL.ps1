# Deploy QualysHostDetectionV2_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-QualysHostDetectionV2_CL.parameters.json"
)

$deploymentName = "dcr-QualysHostDetectionV2_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying QualysHostDetectionV2_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-QualysHostDetectionV2_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
