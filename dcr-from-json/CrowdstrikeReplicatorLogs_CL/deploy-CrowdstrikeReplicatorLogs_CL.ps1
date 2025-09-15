# Deploy CrowdstrikeReplicatorLogs_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-CrowdstrikeReplicatorLogs_CL.parameters.json"
)

$deploymentName = "dcr-CrowdstrikeReplicatorLogs_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying CrowdstrikeReplicatorLogs_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-CrowdstrikeReplicatorLogs_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
