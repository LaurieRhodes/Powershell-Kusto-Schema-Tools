# Deploy NexposeInsightVMCloud_vulnerabilities_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NexposeInsightVMCloud_vulnerabilities_CL.parameters.json"
)

$deploymentName = "dcr-NexposeInsightVMCloud_vulnerabilities_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NexposeInsightVMCloud_vulnerabilities_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NexposeInsightVMCloud_vulnerabilities_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
