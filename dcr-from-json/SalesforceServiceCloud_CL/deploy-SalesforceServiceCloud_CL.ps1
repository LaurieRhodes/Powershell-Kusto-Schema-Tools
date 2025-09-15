# Deploy SalesforceServiceCloud_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SalesforceServiceCloud_CL.parameters.json"
)

$deploymentName = "dcr-SalesforceServiceCloud_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SalesforceServiceCloud_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SalesforceServiceCloud_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
