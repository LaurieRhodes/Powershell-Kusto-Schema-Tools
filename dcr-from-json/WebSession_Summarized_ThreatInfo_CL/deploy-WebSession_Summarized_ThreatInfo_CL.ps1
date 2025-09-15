# Deploy WebSession_Summarized_ThreatInfo_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-WebSession_Summarized_ThreatInfo_CL.parameters.json"
)

$deploymentName = "dcr-WebSession_Summarized_ThreatInfo_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying WebSession_Summarized_ThreatInfo_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-WebSession_Summarized_ThreatInfo_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
