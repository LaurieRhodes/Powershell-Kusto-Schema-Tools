# Deploy Syslog Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Syslog.parameters.json"
)

$deploymentName = "dcr-Syslog-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Syslog Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Syslog.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
