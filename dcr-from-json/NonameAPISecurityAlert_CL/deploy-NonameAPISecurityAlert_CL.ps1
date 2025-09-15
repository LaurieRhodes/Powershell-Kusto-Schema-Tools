# Deploy NonameAPISecurityAlert_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-NonameAPISecurityAlert_CL.parameters.json"
)

$deploymentName = "dcr-NonameAPISecurityAlert_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying NonameAPISecurityAlert_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-NonameAPISecurityAlert_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
