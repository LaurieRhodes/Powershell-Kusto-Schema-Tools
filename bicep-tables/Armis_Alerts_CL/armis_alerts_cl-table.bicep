// Bicep template for Log Analytics custom table: Armis_Alerts_CL
// Generated on 2025-09-13 20:15:18 UTC
// Source: JSON schema export
// Original columns: 20, Deployed columns: 18 (only 'Type' filtered out)
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

resource armisalertsclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Armis_Alerts_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Armis_Alerts_CL'
      description: 'Custom table Armis_Alerts_CL - imported from JSON schema'
      displayName: 'Armis_Alerts_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'TenantId'
          type: 'guid'
          dataTypeHint: 1
        }
        {
          name: 'Time'
          type: 'string'
        }
        {
          name: 'Status'
          type: 'string'
        }
        {
          name: 'Severity'
          type: 'string'
        }
        {
          name: 'DeviceIds'
          type: 'string'
        }
        {
          name: 'Description'
          type: 'string'
        }
        {
          name: 'AlertId'
          type: 'string'
        }
        {
          name: 'Title'
          type: 'string'
        }
        {
          name: 'ActivityUUIDs'
          type: 'string'
        }
        {
          name: 'EventVendor'
          type: 'string'
        }
        {
          name: 'RawData'
          type: 'string'
        }
        {
          name: 'Computer'
          type: 'string'
        }
        {
          name: 'ManagementGroupName'
          type: 'string'
        }
        {
          name: 'MG'
          type: 'string'
        }
        {
          name: 'SourceSystem'
          type: 'string'
        }
        {
          name: 'EventProduct'
          type: 'string'
        }
        {
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
      ]
    }
  }
}

output tableName string = armisalertsclTable.name
output tableId string = armisalertsclTable.id
output provisioningState string = armisalertsclTable.properties.provisioningState
