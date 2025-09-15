# Deploy Workplace_Facebook_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Workplace_Facebook_CL.parameters.json"
)

$deploymentName = "dcr-Workplace_Facebook_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Workplace_Facebook_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Workplace_Facebook_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
