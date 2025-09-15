# Deploy DuoSecurityTrustMonitor_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-DuoSecurityTrustMonitor_CL.parameters.json"
)

$deploymentName = "dcr-DuoSecurityTrustMonitor_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying DuoSecurityTrustMonitor_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-DuoSecurityTrustMonitor_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
