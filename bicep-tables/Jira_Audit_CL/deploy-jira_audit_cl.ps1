# Deploy Jira_Audit_CL Log Analytics Table
# Generated on 2025-09-13 20:15:25 UTC

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$WorkspaceName,
    
    [Parameter(Mandatory=$false)]
    [string]$SubscriptionId = (Get-AzContext).Subscription.Id
)

$deploymentName = "Jira_Audit_CL-table-deployment-$((Get-Date -Format 'yyyyMMdd-HHmmss'))"

Write-Host "Deploying Jira_Audit_CL table to Log Analytics workspace..." -ForegroundColor Cyan
Write-Host "  Workspace: $WorkspaceName" -ForegroundColor Gray
Write-Host "  Resource Group: $ResourceGroupName" -ForegroundColor Gray

try {
    $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -Name $deploymentName `
        -TemplateFile "jira_audit_cl-table.bicep" `
        -workspaceName $WorkspaceName `
        -Verbose
    
    Write-Host "SUCCESS: Table Jira_Audit_CL deployed successfully" -ForegroundColor Green
    Write-Host "Table ID: $($deployment.Outputs.tableId.Value)" -ForegroundColor Gray
    Write-Host "Provisioning State: $($deployment.Outputs.provisioningState.Value)" -ForegroundColor Gray
    
} catch {
    Write-Error "Failed to deploy table Jira_Audit_CL: $($_.Exception.Message)"
    exit 1
}
