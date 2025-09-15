﻿// Bicep template for Log Analytics custom table: MimecastAudit_CL
// Generated on 2025-09-13 20:15:26 UTC
// Source: JSON schema export
// Original columns: 13, Deployed columns: 13 (only 'Type' filtered out)
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

resource mimecastauditclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'MimecastAudit_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'MimecastAudit_CL'
      description: 'Custom table MimecastAudit_CL - imported from JSON schema'
      displayName: 'MimecastAudit_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'id_s'
          type: 'string'
        }
        {
          name: 'auditType_s'
          type: 'string'
        }
        {
          name: 'user_s'
          type: 'string'
        }
        {
          name: 'eventTime_d'
          type: 'dateTime'
        }
        {
          name: 'eventInfo_s'
          type: 'string'
        }
        {
          name: 'category_s'
          type: 'string'
        }
        {
          name: 'mimecastEventId_s'
          type: 'string'
        }
        {
          name: 'mimecastEventCategory_s'
          type: 'string'
        }
        {
          name: 'time_generated'
          type: 'dateTime'
        }
        {
          name: 'app_s'
          type: 'string'
        }
        {
          name: 'src_s'
          type: 'string'
        }
        {
          name: 'method_s'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = mimecastauditclTable.name
output tableId string = mimecastauditclTable.id
output provisioningState string = mimecastauditclTable.properties.provisioningState
