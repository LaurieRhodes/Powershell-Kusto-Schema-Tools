# Deploy ZNAccessOrchestratorAuditNativePoller_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ZNAccessOrchestratorAuditNativePoller_CL.parameters.json"
)

$deploymentName = "dcr-ZNAccessOrchestratorAuditNativePoller_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ZNAccessOrchestratorAuditNativePoller_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ZNAccessOrchestratorAuditNativePoller_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
