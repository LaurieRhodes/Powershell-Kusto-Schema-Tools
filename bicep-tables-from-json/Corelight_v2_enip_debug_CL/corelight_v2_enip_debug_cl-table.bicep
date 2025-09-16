﻿// Bicep template for Log Analytics custom table: Corelight_v2_enip_debug_CL
// Generated on 2025-09-17 06:39:59 UTC
// Source: JSON schema export
// Original columns: 11, Deployed columns: 11 (Type column filtered)
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

resource corelightv2enipdebugclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_enip_debug_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_enip_debug_CL'
      description: 'Custom table Corelight_v2_enip_debug_CL - imported from JSON schema'
      displayName: 'Corelight_v2_enip_debug_CL'
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
          name: 'uid_s'
          type: 'string'
        }
        {
          name: 'id_orig_h_s'
          type: 'string'
        }
        {
          name: 'id_orig_p_d'
          type: 'real'
        }
        {
          name: 'id_resp_h_s'
          type: 'string'
        }
        {
          name: 'id_resp_p_d'
          type: 'real'
        }
        {
          name: 'raw_data_s'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = corelightv2enipdebugclTable.name
output tableId string = corelightv2enipdebugclTable.id
output provisioningState string = corelightv2enipdebugclTable.properties.provisioningState
