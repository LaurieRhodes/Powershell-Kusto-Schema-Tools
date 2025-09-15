# Deploy ZNAccessOrchestratorAudit_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ZNAccessOrchestratorAudit_CL.parameters.json"
)

$deploymentName = "dcr-ZNAccessOrchestratorAudit_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ZNAccessOrchestratorAudit_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ZNAccessOrchestratorAudit_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
