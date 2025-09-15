# Deploy CyberArk_AuditEvents_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CyberArk_AuditEvents_CL.parameters.json"
)

$deploymentName = "dcr-CyberArk_AuditEvents_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CyberArk_AuditEvents_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CyberArk_AuditEvents_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
