# Deploy Ipinfo_Company_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-Ipinfo_Company_CL.parameters.json"
)

$deploymentName = "dcr-Ipinfo_Company_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying Ipinfo_Company_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-Ipinfo_Company_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
