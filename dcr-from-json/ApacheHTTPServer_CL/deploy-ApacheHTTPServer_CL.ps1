# Deploy ApacheHTTPServer_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-ApacheHTTPServer_CL.parameters.json"
)

$deploymentName = "dcr-ApacheHTTPServer_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying ApacheHTTPServer_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-ApacheHTTPServer_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
