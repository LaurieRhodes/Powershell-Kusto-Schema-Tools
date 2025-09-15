# Deploy ASimAuthenticationEventLogs Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimAuthenticationEventLogs.parameters.json"
)

$deploymentName = "dcr-ASimAuthenticationEventLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimAuthenticationEventLogs Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimAuthenticationEventLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
