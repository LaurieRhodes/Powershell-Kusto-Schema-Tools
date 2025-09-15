# Deploy TransmitSecurityAdminActivity_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TransmitSecurityAdminActivity_CL.parameters.json"
)

$deploymentName = "dcr-TransmitSecurityAdminActivity_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TransmitSecurityAdminActivity_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TransmitSecurityAdminActivity_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
