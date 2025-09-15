# Deploy PostgreSQL_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-PostgreSQL_CL.parameters.json"
)

$deploymentName = "dcr-PostgreSQL_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying PostgreSQL_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-PostgreSQL_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
