# Deploy HYASProtectDnsSecurityLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-HYASProtectDnsSecurityLogs_CL.parameters.json"
)

$deploymentName = "dcr-HYASProtectDnsSecurityLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying HYASProtectDnsSecurityLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-HYASProtectDnsSecurityLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
