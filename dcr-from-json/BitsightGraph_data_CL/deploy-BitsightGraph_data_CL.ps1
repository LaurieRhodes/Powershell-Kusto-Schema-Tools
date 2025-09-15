# Deploy BitsightGraph_data_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitsightGraph_data_CL.parameters.json"
)

$deploymentName = "dcr-BitsightGraph_data_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitsightGraph_data_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitsightGraph_data_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
