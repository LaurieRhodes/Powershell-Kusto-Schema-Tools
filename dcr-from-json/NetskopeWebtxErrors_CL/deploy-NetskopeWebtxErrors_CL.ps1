# Deploy NetskopeWebtxErrors_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NetskopeWebtxErrors_CL.parameters.json"
)

$deploymentName = "dcr-NetskopeWebtxErrors_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NetskopeWebtxErrors_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NetskopeWebtxErrors_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
