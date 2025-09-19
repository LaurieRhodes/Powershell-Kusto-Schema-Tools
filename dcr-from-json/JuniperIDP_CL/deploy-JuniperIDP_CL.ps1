# Deploy JuniperIDP_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-JuniperIDP_CL.parameters.json"
)

$deploymentName = "dcr-JuniperIDP_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying JuniperIDP_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-JuniperIDP_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
