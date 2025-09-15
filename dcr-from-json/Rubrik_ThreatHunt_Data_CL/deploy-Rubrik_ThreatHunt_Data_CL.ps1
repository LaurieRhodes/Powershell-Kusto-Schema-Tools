# Deploy Rubrik_ThreatHunt_Data_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Rubrik_ThreatHunt_Data_CL.parameters.json"
)

$deploymentName = "dcr-Rubrik_ThreatHunt_Data_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Rubrik_ThreatHunt_Data_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Rubrik_ThreatHunt_Data_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
