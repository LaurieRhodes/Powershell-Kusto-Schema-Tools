// Bicep template for Log Analytics custom table: Corelight_v2_enip_list_identity_CL
// Generated on 2025-09-17 06:39:59 UTC
// Source: JSON schema export
// Original columns: 19, Deployed columns: 19 (Type column filtered)
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

resource corelightv2eniplistidentityclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_enip_list_identity_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_enip_list_identity_CL'
      description: 'Custom table Corelight_v2_enip_list_identity_CL - imported from JSON schema'
      displayName: 'Corelight_v2_enip_list_identity_CL'
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
          name: 'status_s'
          type: 'string'
        }
        {
          name: 'revision_d'
          type: 'real'
        }
        {
          name: 'product_code_d'
          type: 'real'
        }
        {
          name: 'serial_number_s'
          type: 'string'
        }
        {
          name: 'product_name_s'
          type: 'string'
        }
        {
          name: 'vendor_s'
          type: 'string'
        }
        {
          name: 'device_type_s'
          type: 'string'
        }
        {
          name: 'id_resp_p_d'
          type: 'real'
        }
        {
          name: 'id_resp_h_s'
          type: 'string'
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
          name: 'state_s'
          type: 'string'
        }
        {
          name: 'device_ip_s'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = corelightv2eniplistidentityclTable.name
output tableId string = corelightv2eniplistidentityclTable.id
output provisioningState string = corelightv2eniplistidentityclTable.properties.provisioningState
