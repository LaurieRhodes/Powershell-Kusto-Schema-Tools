# Deploy CommonSecurityLog Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CommonSecurityLog.parameters.json"
)

$deploymentName = "dcr-CommonSecurityLog-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CommonSecurityLog Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CommonSecurityLog.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
