# Deploy NetBackupAlerts_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NetBackupAlerts_CL.parameters.json"
)

$deploymentName = "dcr-NetBackupAlerts_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NetBackupAlerts_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NetBackupAlerts_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
