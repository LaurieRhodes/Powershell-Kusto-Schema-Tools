# Deploy BitwardenGroups_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitwardenGroups_CL.parameters.json"
)

$deploymentName = "dcr-BitwardenGroups_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitwardenGroups_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitwardenGroups_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
