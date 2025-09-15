# Deploy JuniperIDP Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-JuniperIDP.parameters.json"
)

$deploymentName = "dcr-JuniperIDP-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying JuniperIDP Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-JuniperIDP.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
