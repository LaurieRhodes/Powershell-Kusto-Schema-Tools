# Deploy AWSVPCFlow Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-AWSVPCFlow.parameters.json"
)

$deploymentName = "dcr-AWSVPCFlow-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying AWSVPCFlow Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-AWSVPCFlow.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
