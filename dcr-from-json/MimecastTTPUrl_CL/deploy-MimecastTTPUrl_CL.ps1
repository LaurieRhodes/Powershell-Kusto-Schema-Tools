# Deploy MimecastTTPUrl_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MimecastTTPUrl_CL.parameters.json"
)

$deploymentName = "dcr-MimecastTTPUrl_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MimecastTTPUrl_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MimecastTTPUrl_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
