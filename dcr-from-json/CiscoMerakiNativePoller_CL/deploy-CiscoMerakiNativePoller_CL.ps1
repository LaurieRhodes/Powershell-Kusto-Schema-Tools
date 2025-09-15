# Deploy CiscoMerakiNativePoller_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CiscoMerakiNativePoller_CL.parameters.json"
)

$deploymentName = "dcr-CiscoMerakiNativePoller_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CiscoMerakiNativePoller_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CiscoMerakiNativePoller_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
