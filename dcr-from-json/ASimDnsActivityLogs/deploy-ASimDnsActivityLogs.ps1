# Deploy ASimDnsActivityLogs Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimDnsActivityLogs.parameters.json"
)

$deploymentName = "dcr-ASimDnsActivityLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimDnsActivityLogs Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimDnsActivityLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
