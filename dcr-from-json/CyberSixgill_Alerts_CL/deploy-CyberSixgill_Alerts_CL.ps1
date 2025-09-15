# Deploy CyberSixgill_Alerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CyberSixgill_Alerts_CL.parameters.json"
)

$deploymentName = "dcr-CyberSixgill_Alerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CyberSixgill_Alerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CyberSixgill_Alerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
