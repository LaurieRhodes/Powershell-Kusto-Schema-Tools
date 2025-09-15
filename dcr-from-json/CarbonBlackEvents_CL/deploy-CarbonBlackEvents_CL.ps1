# Deploy CarbonBlackEvents_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CarbonBlackEvents_CL.parameters.json"
)

$deploymentName = "dcr-CarbonBlackEvents_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CarbonBlackEvents_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CarbonBlackEvents_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
