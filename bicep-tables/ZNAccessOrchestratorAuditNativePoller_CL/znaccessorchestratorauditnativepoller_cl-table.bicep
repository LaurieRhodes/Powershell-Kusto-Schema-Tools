﻿// Bicep template for Log Analytics custom table: ZNAccessOrchestratorAuditNativePoller_CL
// Generated on 2025-09-13 20:15:30 UTC
// Source: JSON schema export
// Original columns: 11, Deployed columns: 11 (only 'Type' filtered out)
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

resource znaccessorchestratorauditnativepollerclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'ZNAccessOrchestratorAuditNativePoller_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'ZNAccessOrchestratorAuditNativePoller_CL'
      description: 'Custom table ZNAccessOrchestratorAuditNativePoller_CL - imported from JSON schema'
      displayName: 'ZNAccessOrchestratorAuditNativePoller_CL'
      columns: [
        {
          name: 'timestamp_d'
          type: 'real'
        }
        {
          name: 'auditType_d'
          type: 'real'
        }
        {
          name: 'enforcementSource_d'
          type: 'real'
        }
        {
          name: 'userRole_d'
          type: 'real'
        }
        {
          name: 'destinationEntitiesList_s'
          type: 'string'
        }
        {
          name: 'details_s'
          type: 'string'
        }
        {
          name: 'reportedObjectId_g'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'performedBy_id_s'
          type: 'string'
        }
        {
          name: 'performedBy_name_s'
          type: 'string'
        }
        {
          name: 'performedBy_id_g'
          type: 'string'
        }
        {
          name: 'reportedObjectId_s'
          type: 'string'
          dataTypeHint: 1
        }
      ]
    }
  }
}

output tableName string = znaccessorchestratorauditnativepollerclTable.name
output tableId string = znaccessorchestratorauditnativepollerclTable.id
output provisioningState string = znaccessorchestratorauditnativepollerclTable.properties.provisioningState
