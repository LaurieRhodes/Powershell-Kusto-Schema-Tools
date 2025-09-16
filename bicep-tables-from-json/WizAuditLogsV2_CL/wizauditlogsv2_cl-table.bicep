﻿// Bicep template for Log Analytics custom table: WizAuditLogsV2_CL
// Generated on 2025-09-17 06:40:08 UTC
// Source: JSON schema export
// Original columns: 6, Deployed columns: 6 (Type column filtered)
// Underscore columns included
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

resource wizauditlogsv2clTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'WizAuditLogsV2_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'WizAuditLogsV2_CL'
      description: 'Custom table WizAuditLogsV2_CL - imported from JSON schema'
      displayName: 'WizAuditLogsV2_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'user_id_s'
          type: 'string'
        }
        {
          name: 'user_name_s'
          type: 'string'
        }
        {
          name: 'serviceAccount_name_s'
          type: 'string'
        }
        {
          name: 'serviceAccount_id_s'
          type: 'string'
        }
        {
          name: 'timestamp_t'
          type: 'dateTime'
        }
      ]
    }
  }
}

output tableName string = wizauditlogsv2clTable.name
output tableId string = wizauditlogsv2clTable.id
output provisioningState string = wizauditlogsv2clTable.properties.provisioningState
