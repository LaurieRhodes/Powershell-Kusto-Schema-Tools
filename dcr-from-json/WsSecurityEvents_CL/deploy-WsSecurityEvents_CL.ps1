# Deploy WsSecurityEvents_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-WsSecurityEvents_CL.parameters.json"
)

$deploymentName = "dcr-WsSecurityEvents_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying WsSecurityEvents_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-WsSecurityEvents_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
