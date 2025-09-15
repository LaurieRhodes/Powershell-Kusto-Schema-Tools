# Deploy BitwardenMembers_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitwardenMembers_CL.parameters.json"
)

$deploymentName = "dcr-BitwardenMembers_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitwardenMembers_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitwardenMembers_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
