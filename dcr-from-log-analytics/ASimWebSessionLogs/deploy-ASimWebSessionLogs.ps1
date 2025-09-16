# Deploy ASimWebSessionLogs Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ASimWebSessionLogs.parameters.json"
)

$deploymentName = "dcr-ASimWebSessionLogs-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ASimWebSessionLogs Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ASimWebSessionLogs.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
