# Deploy QualysHostDetection_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-QualysHostDetection_CL.parameters.json"
)

$deploymentName = "dcr-QualysHostDetection_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying QualysHostDetection_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-QualysHostDetection_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
