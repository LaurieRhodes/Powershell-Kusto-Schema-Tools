# Deploy FncEventsDetections_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-FncEventsDetections_CL.parameters.json"
)

$deploymentName = "dcr-FncEventsDetections_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying FncEventsDetections_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-FncEventsDetections_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
