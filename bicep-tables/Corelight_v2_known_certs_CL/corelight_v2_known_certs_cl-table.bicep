// Bicep template for Log Analytics custom table: Corelight_v2_known_certs_CL
// Generated on 2025-09-13 20:15:21 UTC
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

resource corelightv2knowncertsclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_known_certs_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_known_certs_CL'
      description: 'Custom table Corelight_v2_known_certs_CL - imported from JSON schema'
      displayName: 'Corelight_v2_known_certs_CL'
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
          name: 'annotations_s'
          type: 'string'
        }
        {
          name: 'num_conns_d'
          type: 'real'
        }
        {
          name: 'issuer_subject_s'
          type: 'string'
        }
        {
          name: 'subject_s'
          type: 'string'
        }
        {
          name: 'serial_s'
          type: 'string'
        }
        {
          name: 'protocol_s'
          type: 'string'
        }
        {
          name: 'last_active_session_s'
          type: 'string'
        }
        {
          name: 'port_num_d'
          type: 'real'
        }
        {
          name: 'host_ip_s'
          type: 'string'
        }
        {
          name: 'kuid_s'
          type: 'string'
        }
        {
          name: 'duration_d'
          type: 'real'
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
          name: 'hash_s'
          type: 'string'
        }
        {
          name: 'last_active_interval_d'
          type: 'real'
        }
      ]
    }
  }
}

output tableName string = corelightv2knowncertsclTable.name
output tableId string = corelightv2knowncertsclTable.id
output provisioningState string = corelightv2knowncertsclTable.properties.provisioningState
