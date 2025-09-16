# Deploy SecurityEvent Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SecurityEvent.parameters.json"
)

$deploymentName = "dcr-SecurityEvent-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SecurityEvent Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SecurityEvent.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
