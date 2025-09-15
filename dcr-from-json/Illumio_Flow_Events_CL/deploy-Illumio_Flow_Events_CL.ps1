# Deploy Illumio_Flow_Events_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Illumio_Flow_Events_CL.parameters.json"
)

$deploymentName = "dcr-Illumio_Flow_Events_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Illumio_Flow_Events_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Illumio_Flow_Events_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
