# Deploy CynerioEvent_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CynerioEvent_CL.parameters.json"
)

$deploymentName = "dcr-CynerioEvent_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CynerioEvent_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CynerioEvent_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
