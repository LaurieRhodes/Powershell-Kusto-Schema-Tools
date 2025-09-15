# Deploy CiscoSDWANNetflow_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CiscoSDWANNetflow_CL.parameters.json"
)

$deploymentName = "dcr-CiscoSDWANNetflow_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CiscoSDWANNetflow_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CiscoSDWANNetflow_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
