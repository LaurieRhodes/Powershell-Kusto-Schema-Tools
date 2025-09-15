# Deploy WizIssuesV2_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-WizIssuesV2_CL.parameters.json"
)

$deploymentName = "dcr-WizIssuesV2_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying WizIssuesV2_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-WizIssuesV2_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
