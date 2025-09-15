# Deploy MailGuard365_Threats_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MailGuard365_Threats_CL.parameters.json"
)

$deploymentName = "dcr-MailGuard365_Threats_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MailGuard365_Threats_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MailGuard365_Threats_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
