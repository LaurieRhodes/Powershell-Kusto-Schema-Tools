# Deploy InfoSecAnalytics_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-InfoSecAnalytics_CL.parameters.json"
)

$deploymentName = "dcr-InfoSecAnalytics_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying InfoSecAnalytics_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-InfoSecAnalytics_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
