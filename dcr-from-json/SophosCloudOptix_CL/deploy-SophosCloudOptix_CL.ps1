# Deploy SophosCloudOptix_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SophosCloudOptix_CL.parameters.json"
)

$deploymentName = "dcr-SophosCloudOptix_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SophosCloudOptix_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SophosCloudOptix_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
