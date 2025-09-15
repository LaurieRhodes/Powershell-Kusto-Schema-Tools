# Deploy BitsightCompany_rating_details_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitsightCompany_rating_details_CL.parameters.json"
)

$deploymentName = "dcr-BitsightCompany_rating_details_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitsightCompany_rating_details_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitsightCompany_rating_details_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
