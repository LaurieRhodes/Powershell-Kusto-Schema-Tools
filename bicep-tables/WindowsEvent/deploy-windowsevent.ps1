# Deploy WindowsEvent Log Analytics Table
# Generated on 2025-09-13 20:15:29 UTC

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$WorkspaceName,
    
    [Parameter(Mandatory=$false)]
    [string]$SubscriptionId = (Get-AzContext).Subscription.Id
)

$deploymentName = "WindowsEvent-table-deployment-$((Get-Date -Format 'yyyyMMdd-HHmmss'))"

Write-Host "Deploying WindowsEvent table to Log Analytics workspace..." -ForegroundColor Cyan
Write-Host "  Workspace: $WorkspaceName" -ForegroundColor Gray
Write-Host "  Resource Group: $ResourceGroupName" -ForegroundColor Gray

try {
    $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -Name $deploymentName `
        -TemplateFile "windowsevent-table.bicep" `
        -workspaceName $WorkspaceName `
        -Verbose
    
    Write-Host "SUCCESS: Table WindowsEvent deployed successfully" -ForegroundColor Green
    Write-Host "Table ID: $($deployment.Outputs.tableId.Value)" -ForegroundColor Gray
    Write-Host "Provisioning State: $($deployment.Outputs.provisioningState.Value)" -ForegroundColor Gray
    
} catch {
    Write-Error "Failed to deploy table WindowsEvent: $($_.Exception.Message)"
    exit 1
}
