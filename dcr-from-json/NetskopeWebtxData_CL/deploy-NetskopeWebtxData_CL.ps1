# Deploy NetskopeWebtxData_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NetskopeWebtxData_CL.parameters.json"
)

$deploymentName = "dcr-NetskopeWebtxData_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NetskopeWebtxData_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NetskopeWebtxData_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
