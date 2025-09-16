﻿// Bicep template for Log Analytics custom table: Corelight_v2_packet_filter_CL
// Generated on 2025-09-17 06:40:00 UTC
// Source: JSON schema export
// Original columns: 9, Deployed columns: 9 (Type column filtered)
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

resource corelightv2packetfilterclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_packet_filter_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_packet_filter_CL'
      description: 'Custom table Corelight_v2_packet_filter_CL - imported from JSON schema'
      displayName: 'Corelight_v2_packet_filter_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: '_path_s'
          type: 'string'
        }
        {
          name: '_system_name_s'
          type: 'string'
        }
        {
          name: '_write_ts_t'
          type: 'dateTime'
        }
        {
          name: 'ts_t'
          type: 'dateTime'
        }
        {
          name: 'node_s'
          type: 'string'
        }
        {
          name: 'filter_s'
          type: 'string'
        }
        {
          name: 'init_b'
          type: 'boolean'
        }
        {
          name: 'success_b'
          type: 'boolean'
        }
      ]
    }
  }
}

output tableName string = corelightv2packetfilterclTable.name
output tableId string = corelightv2packetfilterclTable.id
output provisioningState string = corelightv2packetfilterclTable.properties.provisioningState
