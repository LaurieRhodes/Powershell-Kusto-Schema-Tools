# Deploy BitsightIndustrial_statistics_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitsightIndustrial_statistics_CL.parameters.json"
)

$deploymentName = "dcr-BitsightIndustrial_statistics_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitsightIndustrial_statistics_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitsightIndustrial_statistics_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
