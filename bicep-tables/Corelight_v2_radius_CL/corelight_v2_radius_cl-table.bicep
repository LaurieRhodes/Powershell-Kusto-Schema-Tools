// Bicep template for Log Analytics custom table: Corelight_v2_radius_CL
// Generated on 2025-09-13 20:15:22 UTC
// Source: JSON schema export
// Original columns: 18, Deployed columns: 18 (only 'Type' filtered out)
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

resource corelightv2radiusclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_radius_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_radius_CL'
      description: 'Custom table Corelight_v2_radius_CL - imported from JSON schema'
      displayName: 'Corelight_v2_radius_CL'
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
          name: 'reply_msg_s'
          type: 'string'
        }
        {
          name: 'connect_info_s'
          type: 'string'
        }
        {
          name: 'tunnel_client_s'
          type: 'string'
        }
        {
          name: 'framed_addr_s'
          type: 'string'
        }
        {
          name: 'mac_s'
          type: 'string'
        }
        {
          name: 'username_s'
          type: 'string'
        }
        {
          name: 'result_s'
          type: 'string'
        }
        {
          name: 'id_resp_p_d'
          type: 'real'
        }
        {
          name: 'id_orig_p_d'
          type: 'real'
        }
        {
          name: 'id_orig_h_s'
          type: 'string'
        }
        {
          name: 'uid_s'
          type: 'string'
        }
        {
          name: 'ts_t'
          type: 'dateTime'
        }
        {
          name: '_write_ts_t'
          type: 'dateTime'
        }
        {
          name: '_system_name_s'
          type: 'string'
        }
        {
          name: 'id_resp_h_s'
          type: 'string'
        }
        {
          name: 'ttl_d'
          type: 'real'
        }
      ]
    }
  }
}

output tableName string = corelightv2radiusclTable.name
output tableId string = corelightv2radiusclTable.id
output provisioningState string = corelightv2radiusclTable.properties.provisioningState
