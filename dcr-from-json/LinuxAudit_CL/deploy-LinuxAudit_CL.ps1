# Deploy LinuxAudit_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-LinuxAudit_CL.parameters.json"
)

$deploymentName = "dcr-LinuxAudit_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying LinuxAudit_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-LinuxAudit_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
