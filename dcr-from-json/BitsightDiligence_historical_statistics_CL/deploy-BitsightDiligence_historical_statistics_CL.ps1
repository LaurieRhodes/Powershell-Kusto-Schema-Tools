# Deploy BitsightDiligence_historical_statistics_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitsightDiligence_historical_statistics_CL.parameters.json"
)

$deploymentName = "dcr-BitsightDiligence_historical_statistics_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitsightDiligence_historical_statistics_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitsightDiligence_historical_statistics_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
