# Deploy NetworkCustomAnalytics_protocol_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NetworkCustomAnalytics_protocol_CL.parameters.json"
)

$deploymentName = "dcr-NetworkCustomAnalytics_protocol_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NetworkCustomAnalytics_protocol_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NetworkCustomAnalytics_protocol_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
