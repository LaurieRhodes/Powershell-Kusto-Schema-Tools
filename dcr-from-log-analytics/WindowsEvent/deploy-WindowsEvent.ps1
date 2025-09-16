# Deploy WindowsEvent Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-WindowsEvent.parameters.json"
)

$deploymentName = "dcr-WindowsEvent-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying WindowsEvent Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-WindowsEvent.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
