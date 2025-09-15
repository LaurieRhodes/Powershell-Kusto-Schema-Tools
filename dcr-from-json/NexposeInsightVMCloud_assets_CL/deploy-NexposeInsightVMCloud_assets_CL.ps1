# Deploy NexposeInsightVMCloud_assets_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NexposeInsightVMCloud_assets_CL.parameters.json"
)

$deploymentName = "dcr-NexposeInsightVMCloud_assets_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NexposeInsightVMCloud_assets_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NexposeInsightVMCloud_assets_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
