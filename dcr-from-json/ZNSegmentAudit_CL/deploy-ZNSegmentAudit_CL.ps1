# Deploy ZNSegmentAudit_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ZNSegmentAudit_CL.parameters.json"
)

$deploymentName = "dcr-ZNSegmentAudit_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ZNSegmentAudit_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ZNSegmentAudit_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
