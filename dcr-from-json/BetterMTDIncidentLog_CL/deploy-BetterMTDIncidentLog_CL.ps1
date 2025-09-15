# Deploy BetterMTDIncidentLog_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BetterMTDIncidentLog_CL.parameters.json"
)

$deploymentName = "dcr-BetterMTDIncidentLog_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BetterMTDIncidentLog_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BetterMTDIncidentLog_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
