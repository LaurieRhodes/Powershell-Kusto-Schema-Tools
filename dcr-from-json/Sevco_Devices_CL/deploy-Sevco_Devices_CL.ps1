# Deploy Sevco_Devices_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Sevco_Devices_CL.parameters.json"
)

$deploymentName = "dcr-Sevco_Devices_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Sevco_Devices_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Sevco_Devices_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
