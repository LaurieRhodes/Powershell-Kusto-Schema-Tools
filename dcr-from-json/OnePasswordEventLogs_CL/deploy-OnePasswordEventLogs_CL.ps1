# Deploy OnePasswordEventLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-OnePasswordEventLogs_CL.parameters.json"
)

$deploymentName = "dcr-OnePasswordEventLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying OnePasswordEventLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-OnePasswordEventLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
