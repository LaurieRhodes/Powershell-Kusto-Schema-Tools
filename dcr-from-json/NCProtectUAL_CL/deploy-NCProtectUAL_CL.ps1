# Deploy NCProtectUAL_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NCProtectUAL_CL.parameters.json"
)

$deploymentName = "dcr-NCProtectUAL_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NCProtectUAL_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NCProtectUAL_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
