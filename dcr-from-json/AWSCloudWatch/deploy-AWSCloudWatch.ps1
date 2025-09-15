# Deploy AWSCloudWatch Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-AWSCloudWatch.parameters.json"
)

$deploymentName = "dcr-AWSCloudWatch-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying AWSCloudWatch Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-AWSCloudWatch.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
