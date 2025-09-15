# Deploy BitsightObservation_statistics_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitsightObservation_statistics_CL.parameters.json"
)

$deploymentName = "dcr-BitsightObservation_statistics_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitsightObservation_statistics_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitsightObservation_statistics_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
