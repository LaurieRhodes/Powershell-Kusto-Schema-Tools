# Deploy MimecastAudit_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MimecastAudit_CL.parameters.json"
)

$deploymentName = "dcr-MimecastAudit_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MimecastAudit_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MimecastAudit_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
