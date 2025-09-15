# Deploy ZeroFox_CTI_phishing_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ZeroFox_CTI_phishing_CL.parameters.json"
)

$deploymentName = "dcr-ZeroFox_CTI_phishing_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ZeroFox_CTI_phishing_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ZeroFox_CTI_phishing_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
