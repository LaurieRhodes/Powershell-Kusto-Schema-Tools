# Deploy DomainToolsDomainEnrichment_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-DomainToolsDomainEnrichment_CL.parameters.json"
)

$deploymentName = "dcr-DomainToolsDomainEnrichment_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying DomainToolsDomainEnrichment_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-DomainToolsDomainEnrichment_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
