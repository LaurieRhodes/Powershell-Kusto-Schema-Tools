# Deploy TaniumDiscoverUnmanagedAssets_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TaniumDiscoverUnmanagedAssets_CL.parameters.json"
)

$deploymentName = "dcr-TaniumDiscoverUnmanagedAssets_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TaniumDiscoverUnmanagedAssets_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TaniumDiscoverUnmanagedAssets_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
