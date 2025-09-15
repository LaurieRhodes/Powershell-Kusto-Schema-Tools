# Deploy BetterMTDDeviceLog_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BetterMTDDeviceLog_CL.parameters.json"
)

$deploymentName = "dcr-BetterMTDDeviceLog_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BetterMTDDeviceLog_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BetterMTDDeviceLog_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
