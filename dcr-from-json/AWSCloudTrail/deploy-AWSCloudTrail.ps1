# Deploy AWSCloudTrail Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-AWSCloudTrail.parameters.json"
)

$deploymentName = "dcr-AWSCloudTrail-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying AWSCloudTrail Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-AWSCloudTrail.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
