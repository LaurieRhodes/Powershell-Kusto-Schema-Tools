# Deploy ASimDhcpEventLogs Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimDhcpEventLogs.parameters.json"
)

$deploymentName = "dcr-ASimDhcpEventLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimDhcpEventLogs Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimDhcpEventLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
