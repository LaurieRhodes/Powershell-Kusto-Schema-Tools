# Deploy ProofPointTAPMessagesDelivered_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ProofPointTAPMessagesDelivered_CL.parameters.json"
)

$deploymentName = "dcr-ProofPointTAPMessagesDelivered_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ProofPointTAPMessagesDelivered_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ProofPointTAPMessagesDelivered_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
