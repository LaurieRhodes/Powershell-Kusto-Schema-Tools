# Deploy MongoDBAudit_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MongoDBAudit_CL.parameters.json"
)

$deploymentName = "dcr-MongoDBAudit_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MongoDBAudit_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MongoDBAudit_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
