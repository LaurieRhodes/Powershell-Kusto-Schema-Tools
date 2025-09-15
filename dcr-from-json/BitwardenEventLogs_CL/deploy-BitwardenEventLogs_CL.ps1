# Deploy BitwardenEventLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitwardenEventLogs_CL.parameters.json"
)

$deploymentName = "dcr-BitwardenEventLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitwardenEventLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitwardenEventLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
