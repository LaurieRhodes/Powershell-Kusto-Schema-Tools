# Deploy Tenable_VM_Assets_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Tenable_VM_Assets_CL.parameters.json"
)

$deploymentName = "dcr-Tenable_VM_Assets_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Tenable_VM_Assets_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Tenable_VM_Assets_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
