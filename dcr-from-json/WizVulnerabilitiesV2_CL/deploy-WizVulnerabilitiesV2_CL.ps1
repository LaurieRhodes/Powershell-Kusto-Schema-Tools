# Deploy WizVulnerabilitiesV2_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-WizVulnerabilitiesV2_CL.parameters.json"
)

$deploymentName = "dcr-WizVulnerabilitiesV2_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying WizVulnerabilitiesV2_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-WizVulnerabilitiesV2_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
