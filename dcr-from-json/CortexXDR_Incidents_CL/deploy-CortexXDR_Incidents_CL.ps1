# Deploy CortexXDR_Incidents_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CortexXDR_Incidents_CL.parameters.json"
)

$deploymentName = "dcr-CortexXDR_Incidents_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CortexXDR_Incidents_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CortexXDR_Incidents_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
