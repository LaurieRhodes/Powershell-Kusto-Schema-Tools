# Deploy Ipinfo_Location_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Ipinfo_Location_CL.parameters.json"
)

$deploymentName = "dcr-Ipinfo_Location_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Ipinfo_Location_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Ipinfo_Location_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
