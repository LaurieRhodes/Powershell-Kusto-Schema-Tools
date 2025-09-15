# Deploy MimecastTTPImpersonation_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MimecastTTPImpersonation_CL.parameters.json"
)

$deploymentName = "dcr-MimecastTTPImpersonation_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MimecastTTPImpersonation_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MimecastTTPImpersonation_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
