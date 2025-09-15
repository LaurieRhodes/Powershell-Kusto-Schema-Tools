# Deploy InfobloxInsightComments_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-InfobloxInsightComments_CL.parameters.json"
)

$deploymentName = "dcr-InfobloxInsightComments_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying InfobloxInsightComments_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-InfobloxInsightComments_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
