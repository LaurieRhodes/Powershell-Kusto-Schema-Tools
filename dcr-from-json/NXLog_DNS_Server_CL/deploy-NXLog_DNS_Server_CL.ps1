# Deploy NXLog_DNS_Server_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NXLog_DNS_Server_CL.parameters.json"
)

$deploymentName = "dcr-NXLog_DNS_Server_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NXLog_DNS_Server_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NXLog_DNS_Server_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
