# Deploy ASimUserManagementActivityLogs Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimUserManagementActivityLogs.parameters.json"
)

$deploymentName = "dcr-ASimUserManagementActivityLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimUserManagementActivityLogs Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimUserManagementActivityLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
