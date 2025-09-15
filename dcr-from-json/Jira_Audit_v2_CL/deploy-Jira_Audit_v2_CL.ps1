# Deploy Jira_Audit_v2_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Jira_Audit_v2_CL.parameters.json"
)

$deploymentName = "dcr-Jira_Audit_v2_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Jira_Audit_v2_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Jira_Audit_v2_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
