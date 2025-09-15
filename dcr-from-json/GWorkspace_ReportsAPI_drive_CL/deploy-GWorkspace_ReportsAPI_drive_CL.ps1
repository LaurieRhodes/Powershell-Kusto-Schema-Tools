# Deploy GWorkspace_ReportsAPI_drive_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-GWorkspace_ReportsAPI_drive_CL.parameters.json"
)

$deploymentName = "dcr-GWorkspace_ReportsAPI_drive_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying GWorkspace_ReportsAPI_drive_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-GWorkspace_ReportsAPI_drive_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
