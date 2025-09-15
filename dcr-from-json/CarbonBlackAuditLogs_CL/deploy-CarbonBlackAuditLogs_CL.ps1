# Deploy CarbonBlackAuditLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CarbonBlackAuditLogs_CL.parameters.json"
)

$deploymentName = "dcr-CarbonBlackAuditLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CarbonBlackAuditLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CarbonBlackAuditLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
