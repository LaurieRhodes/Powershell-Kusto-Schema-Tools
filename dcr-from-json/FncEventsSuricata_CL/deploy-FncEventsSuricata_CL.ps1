# Deploy FncEventsSuricata_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-FncEventsSuricata_CL.parameters.json"
)

$deploymentName = "dcr-FncEventsSuricata_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying FncEventsSuricata_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-FncEventsSuricata_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
