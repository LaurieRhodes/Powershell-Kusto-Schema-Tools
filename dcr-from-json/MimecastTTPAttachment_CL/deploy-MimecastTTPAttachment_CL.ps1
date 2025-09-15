# Deploy MimecastTTPAttachment_CL Data Collection Rule (from JSON export)
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-MimecastTTPAttachment_CL.parameters.json"
)

$deploymentName = "dcr-MimecastTTPAttachment_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying MimecastTTPAttachment_CL Data Collection Rule (from JSON export)..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-MimecastTTPAttachment_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
