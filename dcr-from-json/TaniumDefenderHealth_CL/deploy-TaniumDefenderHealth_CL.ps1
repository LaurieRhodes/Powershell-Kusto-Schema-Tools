# Deploy TaniumDefenderHealth_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TaniumDefenderHealth_CL.parameters.json"
)

$deploymentName = "dcr-TaniumDefenderHealth_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TaniumDefenderHealth_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TaniumDefenderHealth_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
