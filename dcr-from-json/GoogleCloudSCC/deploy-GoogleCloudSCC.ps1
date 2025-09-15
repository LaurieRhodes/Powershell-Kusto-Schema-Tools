# Deploy GoogleCloudSCC Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-GoogleCloudSCC.parameters.json"
)

$deploymentName = "dcr-GoogleCloudSCC-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying GoogleCloudSCC Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-GoogleCloudSCC.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
