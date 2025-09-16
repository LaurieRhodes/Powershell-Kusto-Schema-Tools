# Deploy ASimFileEventLogs Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimFileEventLogs.parameters.json"
)

$deploymentName = "dcr-ASimFileEventLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimFileEventLogs Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimFileEventLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
