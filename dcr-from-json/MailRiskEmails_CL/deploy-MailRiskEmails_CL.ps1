# Deploy MailRiskEmails_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MailRiskEmails_CL.parameters.json"
)

$deploymentName = "dcr-MailRiskEmails_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MailRiskEmails_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MailRiskEmails_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
