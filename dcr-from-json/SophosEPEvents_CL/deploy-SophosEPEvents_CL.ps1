# Deploy SophosEPEvents_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-SophosEPEvents_CL.parameters.json"
)

$deploymentName = "dcr-SophosEPEvents_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying SophosEPEvents_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-SophosEPEvents_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
