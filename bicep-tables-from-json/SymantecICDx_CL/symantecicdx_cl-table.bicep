﻿// Bicep template for Log Analytics custom table: SymantecICDx_CL
// Generated on 2025-09-17 06:40:06 UTC
// Source: JSON schema export
// Original columns: 11, Deployed columns: 10 (Type column filtered)
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

resource symantecicdxclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'SymantecICDx_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'SymantecICDx_CL'
      description: 'Custom table SymantecICDx_CL - imported from JSON schema'
      displayName: 'SymantecICDx_CL'
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
          name: 'SourceSystem'
          type: 'string'
        }
        {
          name: 'Computer'
          type: 'string'
        }
        {
          name: 'MG'
          type: 'string'
        }
        {
          name: 'ManagementGroupName'
          type: 'string'
        }
        {
          name: 'RawData'
          type: 'string'
        }
        {
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: 'connection_src_ip_s'
          type: 'string'
        }
        {
          name: 'threat_id_d'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = symantecicdxclTable.name
output tableId string = symantecicdxclTable.id
output provisioningState string = symantecicdxclTable.properties.provisioningState
