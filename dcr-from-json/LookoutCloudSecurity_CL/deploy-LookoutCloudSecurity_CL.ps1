# Deploy LookoutCloudSecurity_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-LookoutCloudSecurity_CL.parameters.json"
)

$deploymentName = "dcr-LookoutCloudSecurity_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying LookoutCloudSecurity_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-LookoutCloudSecurity_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
