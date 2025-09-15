# Deploy TaniumThreatResponse_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TaniumThreatResponse_CL.parameters.json"
)

$deploymentName = "dcr-TaniumThreatResponse_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TaniumThreatResponse_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TaniumThreatResponse_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
