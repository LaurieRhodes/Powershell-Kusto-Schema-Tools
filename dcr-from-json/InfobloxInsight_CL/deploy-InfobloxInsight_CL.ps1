# Deploy InfobloxInsight_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-InfobloxInsight_CL.parameters.json"
)

$deploymentName = "dcr-InfobloxInsight_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying InfobloxInsight_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-InfobloxInsight_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
