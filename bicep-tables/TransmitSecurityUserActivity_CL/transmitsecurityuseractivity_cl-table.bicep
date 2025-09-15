// Bicep template for Log Analytics custom table: TransmitSecurityUserActivity_CL
// Generated on 2025-09-13 20:15:28 UTC
// Source: JSON schema export
// Original columns: 6, Deployed columns: 6 (only 'Type' filtered out)
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

resource transmitsecurityuseractivityclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'TransmitSecurityUserActivity_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'TransmitSecurityUserActivity_CL'
      description: 'Custom table TransmitSecurityUserActivity_CL - imported from JSON schema'
      displayName: 'TransmitSecurityUserActivity_CL'
      columns: [
        {
          name: 'activity'
          type: 'string'
        }
        {
          name: 'app_id'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'ip'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'timestamp'
          type: 'dateTime'
        }
        {
          name: 'user_agent'
          type: 'string'
        }
        {
          name: 'user_id'
          type: 'string'
          dataTypeHint: 1
        }
      ]
    }
  }
}

output tableName string = transmitsecurityuseractivityclTable.name
output tableId string = transmitsecurityuseractivityclTable.id
output provisioningState string = transmitsecurityuseractivityclTable.properties.provisioningState
