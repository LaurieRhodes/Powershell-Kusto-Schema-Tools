# Deploy VMware_VECO_EventLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-VMware_VECO_EventLogs_CL.parameters.json"
)

$deploymentName = "dcr-VMware_VECO_EventLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying VMware_VECO_EventLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-VMware_VECO_EventLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
