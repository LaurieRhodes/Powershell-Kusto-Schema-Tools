# Deploy InfobloxInsightAssets_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-InfobloxInsightAssets_CL.parameters.json"
)

$deploymentName = "dcr-InfobloxInsightAssets_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying InfobloxInsightAssets_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-InfobloxInsightAssets_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
