# Deploy VMware_SDWAN_FirewallLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-VMware_SDWAN_FirewallLogs_CL.parameters.json"
)

$deploymentName = "dcr-VMware_SDWAN_FirewallLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying VMware_SDWAN_FirewallLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-VMware_SDWAN_FirewallLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
