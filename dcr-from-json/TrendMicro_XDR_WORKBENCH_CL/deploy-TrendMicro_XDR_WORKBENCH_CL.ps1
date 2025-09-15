# Deploy TrendMicro_XDR_WORKBENCH_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TrendMicro_XDR_WORKBENCH_CL.parameters.json"
)

$deploymentName = "dcr-TrendMicro_XDR_WORKBENCH_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TrendMicro_XDR_WORKBENCH_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TrendMicro_XDR_WORKBENCH_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
