# Deploy DuoSecurityAdministration_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-DuoSecurityAdministration_CL.parameters.json"
)

$deploymentName = "dcr-DuoSecurityAdministration_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying DuoSecurityAdministration_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-DuoSecurityAdministration_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
