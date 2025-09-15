# Deploy CarbonBlackNotifications_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CarbonBlackNotifications_CL.parameters.json"
)

$deploymentName = "dcr-CarbonBlackNotifications_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CarbonBlackNotifications_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CarbonBlackNotifications_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
