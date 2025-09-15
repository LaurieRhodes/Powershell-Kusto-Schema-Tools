# Deploy Corelight_v2_mysql_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Corelight_v2_mysql_CL.parameters.json"
)

$deploymentName = "dcr-Corelight_v2_mysql_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Corelight_v2_mysql_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Corelight_v2_mysql_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
