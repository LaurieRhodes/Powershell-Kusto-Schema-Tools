# Deploy ImpervaWAFCloud_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ImpervaWAFCloud_CL.parameters.json"
)

$deploymentName = "dcr-ImpervaWAFCloud_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ImpervaWAFCloud_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ImpervaWAFCloud_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
