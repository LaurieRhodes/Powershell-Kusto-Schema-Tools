# Deploy ASimFileEventLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimFileEventLogs_CL.parameters.json"
)

$deploymentName = "dcr-ASimFileEventLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimFileEventLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimFileEventLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
