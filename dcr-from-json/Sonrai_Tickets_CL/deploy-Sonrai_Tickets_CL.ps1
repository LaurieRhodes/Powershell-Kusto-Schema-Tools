# Deploy Sonrai_Tickets_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Sonrai_Tickets_CL.parameters.json"
)

$deploymentName = "dcr-Sonrai_Tickets_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Sonrai_Tickets_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Sonrai_Tickets_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
