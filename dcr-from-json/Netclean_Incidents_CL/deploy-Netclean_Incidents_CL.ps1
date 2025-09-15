# Deploy Netclean_Incidents_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Netclean_Incidents_CL.parameters.json"
)

$deploymentName = "dcr-Netclean_Incidents_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Netclean_Incidents_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Netclean_Incidents_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
