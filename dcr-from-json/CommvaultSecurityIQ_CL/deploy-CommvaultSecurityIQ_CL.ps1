# Deploy CommvaultSecurityIQ_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CommvaultSecurityIQ_CL.parameters.json"
)

$deploymentName = "dcr-CommvaultSecurityIQ_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CommvaultSecurityIQ_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CommvaultSecurityIQ_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
