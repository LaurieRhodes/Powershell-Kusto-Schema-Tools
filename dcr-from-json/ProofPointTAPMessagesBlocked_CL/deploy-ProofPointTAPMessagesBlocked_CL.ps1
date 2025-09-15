# Deploy ProofPointTAPMessagesBlocked_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ProofPointTAPMessagesBlocked_CL.parameters.json"
)

$deploymentName = "dcr-ProofPointTAPMessagesBlocked_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ProofPointTAPMessagesBlocked_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ProofPointTAPMessagesBlocked_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
