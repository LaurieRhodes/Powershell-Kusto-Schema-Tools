# Deploy GoogleCloudSCC Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-GoogleCloudSCC.parameters.json"
)

$deploymentName = "dcr-GoogleCloudSCC-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying GoogleCloudSCC Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-GoogleCloudSCC.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
