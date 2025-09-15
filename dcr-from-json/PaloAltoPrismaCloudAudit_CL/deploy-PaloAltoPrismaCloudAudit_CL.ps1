# Deploy PaloAltoPrismaCloudAudit_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-PaloAltoPrismaCloudAudit_CL.parameters.json"
)

$deploymentName = "dcr-PaloAltoPrismaCloudAudit_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying PaloAltoPrismaCloudAudit_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-PaloAltoPrismaCloudAudit_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
