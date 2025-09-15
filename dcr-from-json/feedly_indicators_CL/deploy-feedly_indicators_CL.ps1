# Deploy feedly_indicators_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-feedly_indicators_CL.parameters.json"
)

$deploymentName = "dcr-feedly_indicators_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying feedly_indicators_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-feedly_indicators_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
