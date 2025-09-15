# Deploy OCI_Logs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-OCI_Logs_CL.parameters.json"
)

$deploymentName = "dcr-OCI_Logs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying OCI_Logs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-OCI_Logs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
