# Deploy DuoSecurityAuthentication_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-DuoSecurityAuthentication_CL.parameters.json"
)

$deploymentName = "dcr-DuoSecurityAuthentication_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying DuoSecurityAuthentication_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-DuoSecurityAuthentication_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
