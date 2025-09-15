# Deploy PaloAltoPrismaCloudAlert_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-PaloAltoPrismaCloudAlert_CL.parameters.json"
)

$deploymentName = "dcr-PaloAltoPrismaCloudAlert_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying PaloAltoPrismaCloudAlert_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-PaloAltoPrismaCloudAlert_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
