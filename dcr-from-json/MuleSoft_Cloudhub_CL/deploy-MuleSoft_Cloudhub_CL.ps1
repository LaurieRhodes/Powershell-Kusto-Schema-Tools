# Deploy MuleSoft_Cloudhub_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MuleSoft_Cloudhub_CL.parameters.json"
)

$deploymentName = "dcr-MuleSoft_Cloudhub_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MuleSoft_Cloudhub_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MuleSoft_Cloudhub_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
