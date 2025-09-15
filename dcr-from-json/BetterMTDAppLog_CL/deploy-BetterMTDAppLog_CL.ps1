# Deploy BetterMTDAppLog_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BetterMTDAppLog_CL.parameters.json"
)

$deploymentName = "dcr-BetterMTDAppLog_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BetterMTDAppLog_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BetterMTDAppLog_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
