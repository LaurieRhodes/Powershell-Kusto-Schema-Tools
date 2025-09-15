# Deploy CiscoSecureEndpoint_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CiscoSecureEndpoint_CL.parameters.json"
)

$deploymentName = "dcr-CiscoSecureEndpoint_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CiscoSecureEndpoint_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CiscoSecureEndpoint_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
