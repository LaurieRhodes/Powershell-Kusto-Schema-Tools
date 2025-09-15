# Deploy DuoSecurityTelephony_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-DuoSecurityTelephony_CL.parameters.json"
)

$deploymentName = "dcr-DuoSecurityTelephony_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying DuoSecurityTelephony_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-DuoSecurityTelephony_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
