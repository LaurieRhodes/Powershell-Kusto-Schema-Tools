# Deploy CrowdStrike_Secondary_Data_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CrowdStrike_Secondary_Data_CL.parameters.json"
)

$deploymentName = "dcr-CrowdStrike_Secondary_Data_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CrowdStrike_Secondary_Data_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CrowdStrike_Secondary_Data_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
