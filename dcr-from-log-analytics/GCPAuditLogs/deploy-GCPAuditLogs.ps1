# Deploy GCPAuditLogs Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-GCPAuditLogs.parameters.json"
)

$deploymentName = "dcr-GCPAuditLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying GCPAuditLogs Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-GCPAuditLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
