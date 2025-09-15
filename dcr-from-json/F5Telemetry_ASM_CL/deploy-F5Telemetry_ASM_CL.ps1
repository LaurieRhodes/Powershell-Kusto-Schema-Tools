# Deploy F5Telemetry_ASM_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-F5Telemetry_ASM_CL.parameters.json"
)

$deploymentName = "dcr-F5Telemetry_ASM_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying F5Telemetry_ASM_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-F5Telemetry_ASM_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
