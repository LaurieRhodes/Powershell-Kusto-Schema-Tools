# Deploy SecurityScorecardFactor_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SecurityScorecardFactor_CL.parameters.json"
)

$deploymentName = "dcr-SecurityScorecardFactor_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SecurityScorecardFactor_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SecurityScorecardFactor_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
