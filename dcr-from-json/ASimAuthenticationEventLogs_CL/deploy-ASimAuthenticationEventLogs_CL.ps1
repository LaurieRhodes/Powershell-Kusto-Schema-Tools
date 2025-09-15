# Deploy ASimAuthenticationEventLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimAuthenticationEventLogs_CL.parameters.json"
)

$deploymentName = "dcr-ASimAuthenticationEventLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimAuthenticationEventLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimAuthenticationEventLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
