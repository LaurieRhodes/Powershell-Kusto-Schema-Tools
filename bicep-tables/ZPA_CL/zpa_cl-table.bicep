// Bicep template for Log Analytics custom table: ZPA_CL
// Generated on 2025-09-13 20:15:30 UTC
// Source: JSON schema export
// Original columns: 7, Deployed columns: 6 (only 'Type' filtered out)
// dataTypeHint values: 0=Uri, 1=Guid, 2=ArmPath, 3=IP

@description('Log Analytics Workspace name')
param workspaceName string

@description('Table plan - Analytics or Basic')
@allowed(['Analytics', 'Basic'])
param tablePlan string = 'Analytics'

@description('Data retention period in days')
@minValue(4)
@maxValue(730)
param retentionInDays int = 30

@description('Total retention period in days')
@minValue(4)
@maxValue(4383)
param totalRetentionInDays int = 30

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: workspaceName
}

resource zpaclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'ZPA_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'ZPA_CL'
      description: 'Custom table ZPA_CL - imported from JSON schema'
      displayName: 'ZPA_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'Computer'
          type: 'string'
        }
        {
          name: 'RawData'
          type: 'string'
        }
        {
          name: 'Message'
          type: 'string'
        }
        {
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: '_SubscriptionId'
          type: 'string'
          dataTypeHint: 1
        }
      ]
    }
  }
}

output tableName string = zpaclTable.name
output tableId string = zpaclTable.id
output provisioningState string = zpaclTable.properties.provisioningState
