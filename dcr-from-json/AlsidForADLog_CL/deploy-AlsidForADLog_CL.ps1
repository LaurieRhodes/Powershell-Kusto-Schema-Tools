# Deploy AlsidForADLog_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-AlsidForADLog_CL.parameters.json"
)

$deploymentName = "dcr-AlsidForADLog_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying AlsidForADLog_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-AlsidForADLog_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
