# Deploy SecurityBridgeLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SecurityBridgeLogs_CL.parameters.json"
)

$deploymentName = "dcr-SecurityBridgeLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SecurityBridgeLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SecurityBridgeLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
