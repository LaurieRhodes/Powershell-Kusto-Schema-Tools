# Deploy TaniumComplyVulnerabilities_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TaniumComplyVulnerabilities_CL.parameters.json"
)

$deploymentName = "dcr-TaniumComplyVulnerabilities_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TaniumComplyVulnerabilities_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TaniumComplyVulnerabilities_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
