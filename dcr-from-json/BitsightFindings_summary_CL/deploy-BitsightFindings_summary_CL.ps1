# Deploy BitsightFindings_summary_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-BitsightFindings_summary_CL.parameters.json"
)

$deploymentName = "dcr-BitsightFindings_summary_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying BitsightFindings_summary_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-BitsightFindings_summary_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
