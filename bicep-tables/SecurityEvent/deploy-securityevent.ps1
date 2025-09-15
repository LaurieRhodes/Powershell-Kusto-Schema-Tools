# Deploy SecurityEvent Log Analytics Table
# Generated on 2025-09-13 20:15:27 UTC

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$WorkspaceName,
    
    [Parameter(Mandatory=$false)]
    [string]$SubscriptionId = (Get-AzContext).Subscription.Id
)

$deploymentName = "SecurityEvent-table-deployment-$((Get-Date -Format 'yyyyMMdd-HHmmss'))"

Write-Host "Deploying SecurityEvent table to Log Analytics workspace..." -ForegroundColor Cyan
Write-Host "  Workspace: $WorkspaceName" -ForegroundColor Gray
Write-Host "  Resource Group: $ResourceGroupName" -ForegroundColor Gray

try {
    $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -Name $deploymentName `
        -TemplateFile "securityevent-table.bicep" `
        -workspaceName $WorkspaceName `
        -Verbose
    
    Write-Host "SUCCESS: Table SecurityEvent deployed successfully" -ForegroundColor Green
    Write-Host "Table ID: $($deployment.Outputs.tableId.Value)" -ForegroundColor Gray
    Write-Host "Provisioning State: $($deployment.Outputs.provisioningState.Value)" -ForegroundColor Gray
    
} catch {
    Write-Error "Failed to deploy table SecurityEvent: $($_.Exception.Message)"
    exit 1
}
