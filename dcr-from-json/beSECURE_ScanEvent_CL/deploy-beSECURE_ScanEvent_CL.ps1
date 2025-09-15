# Deploy beSECURE_ScanEvent_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-beSECURE_ScanEvent_CL.parameters.json"
)

$deploymentName = "dcr-beSECURE_ScanEvent_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying beSECURE_ScanEvent_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-beSECURE_ScanEvent_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
