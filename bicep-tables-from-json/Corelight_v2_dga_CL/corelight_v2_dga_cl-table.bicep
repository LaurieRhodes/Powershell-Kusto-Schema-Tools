﻿// Bicep template for Log Analytics custom table: Corelight_v2_dga_CL
// Generated on 2025-09-17 06:39:59 UTC
// Source: JSON schema export
// Original columns: 15, Deployed columns: 15 (Type column filtered)
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

resource corelightv2dgaclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_dga_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_dga_CL'
      description: 'Custom table Corelight_v2_dga_CL - imported from JSON schema'
      displayName: 'Corelight_v2_dga_CL'
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
          name: 'query_s'
          type: 'string'
        }
        {
          name: 'family_s'
          type: 'string'
        }
        {
          name: 'qtype_name_s'
          type: 'string'
        }
        {
          name: 'rcode_d'
          type: 'real'
        }
        {
          name: 'is_collision_heavy_b'
          type: 'boolean'
        }
        {
          name: 'ruse_b'
          type: 'boolean'
        }
      ]
    }
  }
}

output tableName string = corelightv2dgaclTable.name
output tableId string = corelightv2dgaclTable.id
output provisioningState string = corelightv2dgaclTable.properties.provisioningState
