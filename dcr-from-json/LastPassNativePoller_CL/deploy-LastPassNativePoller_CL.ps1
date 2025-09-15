# Deploy LastPassNativePoller_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-LastPassNativePoller_CL.parameters.json"
)

$deploymentName = "dcr-LastPassNativePoller_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying LastPassNativePoller_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-LastPassNativePoller_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
