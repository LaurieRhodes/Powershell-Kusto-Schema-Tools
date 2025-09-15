# Deploy HackerViewLog_Azure_1_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-HackerViewLog_Azure_1_CL.parameters.json"
)

$deploymentName = "dcr-HackerViewLog_Azure_1_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying HackerViewLog_Azure_1_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-HackerViewLog_Azure_1_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
