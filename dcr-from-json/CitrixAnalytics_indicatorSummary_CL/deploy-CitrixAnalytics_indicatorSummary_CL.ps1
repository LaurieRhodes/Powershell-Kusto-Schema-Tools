# Deploy CitrixAnalytics_indicatorSummary_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CitrixAnalytics_indicatorSummary_CL.parameters.json"
)

$deploymentName = "dcr-CitrixAnalytics_indicatorSummary_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CitrixAnalytics_indicatorSummary_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CitrixAnalytics_indicatorSummary_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
