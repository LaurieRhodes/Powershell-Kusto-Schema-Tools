# Deploy MimecastSIEM_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MimecastSIEM_CL.parameters.json"
)

$deploymentName = "dcr-MimecastSIEM_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MimecastSIEM_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MimecastSIEM_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
