# Deploy WizVulnerabilities_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-WizVulnerabilities_CL.parameters.json"
)

$deploymentName = "dcr-WizVulnerabilities_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying WizVulnerabilities_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-WizVulnerabilities_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
