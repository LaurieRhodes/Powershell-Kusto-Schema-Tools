# Deploy TrendMicroCAS_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TrendMicroCAS_CL.parameters.json"
)

$deploymentName = "dcr-TrendMicroCAS_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TrendMicroCAS_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TrendMicroCAS_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
