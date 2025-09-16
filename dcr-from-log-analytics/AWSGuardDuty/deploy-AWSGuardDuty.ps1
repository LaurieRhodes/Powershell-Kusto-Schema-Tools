# Deploy AWSGuardDuty Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-AWSGuardDuty.parameters.json"
)

$deploymentName = "dcr-AWSGuardDuty-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying AWSGuardDuty Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-AWSGuardDuty.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
