# Deploy ProofpointPOD_maillog_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ProofpointPOD_maillog_CL.parameters.json"
)

$deploymentName = "dcr-ProofpointPOD_maillog_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ProofpointPOD_maillog_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ProofpointPOD_maillog_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
