# Deploy ASimAuditEventLogs Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimAuditEventLogs.parameters.json"
)

$deploymentName = "dcr-ASimAuditEventLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimAuditEventLogs Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimAuditEventLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
