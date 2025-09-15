# Deploy FncEventsObservation_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-FncEventsObservation_CL.parameters.json"
)

$deploymentName = "dcr-FncEventsObservation_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying FncEventsObservation_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-FncEventsObservation_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
