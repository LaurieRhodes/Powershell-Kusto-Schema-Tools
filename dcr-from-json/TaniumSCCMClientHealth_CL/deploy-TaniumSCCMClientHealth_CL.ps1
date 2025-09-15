# Deploy TaniumSCCMClientHealth_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TaniumSCCMClientHealth_CL.parameters.json"
)

$deploymentName = "dcr-TaniumSCCMClientHealth_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TaniumSCCMClientHealth_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TaniumSCCMClientHealth_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
