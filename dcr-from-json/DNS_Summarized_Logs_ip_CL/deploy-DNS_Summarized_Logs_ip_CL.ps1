# Deploy DNS_Summarized_Logs_ip_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-DNS_Summarized_Logs_ip_CL.parameters.json"
)

$deploymentName = "dcr-DNS_Summarized_Logs_ip_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying DNS_Summarized_Logs_ip_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-DNS_Summarized_Logs_ip_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
