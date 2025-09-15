# Deploy SecurityScorecardRatings_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SecurityScorecardRatings_CL.parameters.json"
)

$deploymentName = "dcr-SecurityScorecardRatings_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SecurityScorecardRatings_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SecurityScorecardRatings_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
