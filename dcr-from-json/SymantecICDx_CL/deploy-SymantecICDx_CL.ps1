# Deploy SymantecICDx_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SymantecICDx_CL.parameters.json"
)

$deploymentName = "dcr-SymantecICDx_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SymantecICDx_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SymantecICDx_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
