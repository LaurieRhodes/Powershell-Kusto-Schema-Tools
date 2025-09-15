# Deploy ProofPointTAPClicksBlocked_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ProofPointTAPClicksBlocked_CL.parameters.json"
)

$deploymentName = "dcr-ProofPointTAPClicksBlocked_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ProofPointTAPClicksBlocked_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ProofPointTAPClicksBlocked_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
