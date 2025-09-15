# Deploy BetterMTDNetflowLog_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BetterMTDNetflowLog_CL.parameters.json"
)

$deploymentName = "dcr-BetterMTDNetflowLog_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BetterMTDNetflowLog_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BetterMTDNetflowLog_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
