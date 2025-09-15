# Deploy ASimProcessEventLogs Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimProcessEventLogs.parameters.json"
)

$deploymentName = "dcr-ASimProcessEventLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimProcessEventLogs Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimProcessEventLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
