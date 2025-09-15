# Deploy CitrixAnalytics_userProfile_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CitrixAnalytics_userProfile_CL.parameters.json"
)

$deploymentName = "dcr-CitrixAnalytics_userProfile_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CitrixAnalytics_userProfile_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CitrixAnalytics_userProfile_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
