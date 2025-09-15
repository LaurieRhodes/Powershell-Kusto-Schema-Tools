# Deploy CyberpionActionItems_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CyberpionActionItems_CL.parameters.json"
)

$deploymentName = "dcr-CyberpionActionItems_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CyberpionActionItems_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CyberpionActionItems_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
