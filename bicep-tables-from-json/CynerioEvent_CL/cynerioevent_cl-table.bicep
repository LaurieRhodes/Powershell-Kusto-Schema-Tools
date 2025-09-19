// Bicep template for Log Analytics custom table: CynerioEvent_CL
// Generated on 2025-09-19 14:13:54 UTC
// Source: JSON schema export
// Original columns: 39, Deployed columns: 37 (Type column filtered)
// Underscore columns filtered out
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

resource cynerioeventclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'CynerioEvent_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'CynerioEvent_CL'
      description: 'Custom table CynerioEvent_CL - imported from JSON schema'
      displayName: 'CynerioEvent_CL'
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
          name: 'asset_id_g'
          type: 'string'
        }
        {
          name: 'asset_ip_s'
          type: 'string'
        }
        {
          name: 'asset_model_s'
          type: 'string'
        }
        {
          name: 'asset_name_s'
          type: 'string'
        }
        {
          name: 'asset_type_s'
          type: 'string'
        }
        {
          name: 'asset_type_code_s'
          type: 'string'
        }
        {
          name: 'asset_asset_type_code_s'
          type: 'string'
        }
        {
          name: 'client_ip_s'
          type: 'string'
        }
        {
          name: 'id_g'
          type: 'string'
        }
        {
          name: 'module_s'
          type: 'string'
        }
        {
          name: 'port_d'
          type: 'real'
        }
        {
          name: 'related_risks_s'
          type: 'string'
        }
        {
          name: 'server_ip_s'
          type: 'string'
        }
        {
          name: 'severity_s'
          type: 'string'
        }
        {
          name: 'details_s'
          type: 'string'
        }
        {
          name: 'status_code_s'
          type: 'string'
        }
        {
          name: 'Severity'
          type: 'int'
        }
        {
          name: 'host_s'
          type: 'string'
        }
        {
          name: 'SourceSystem'
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
          name: 'Computer'
          type: 'string'
        }
        {
          name: 'RawData'
          type: 'string'
        }
        {
          name: 'date_t'
          type: 'dateTime'
        }
        {
          name: 'asset_id_s'
          type: 'string'
        }
        {
          name: 'dst_ip_s'
          type: 'string'
        }
        {
          name: 'src_ip_s'
          type: 'string'
        }
        {
          name: 'trans_s'
          type: 'string'
        }
        {
          name: 'uid_s'
          type: 'string'
        }
        {
          name: 'service_s'
          type: 'string'
        }
        {
          name: 'new_status_s'
          type: 'string'
        }
        {
          name: 'risk_name_s'
          type: 'string'
        }
        {
          name: 'browser_s'
          type: 'string'
        }
        {
          name: 'timestamp_d'
          type: 'real'
        }
        {
          name: 'title_s'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = cynerioeventclTable.name
output tableId string = cynerioeventclTable.id
output provisioningState string = cynerioeventclTable.properties.provisioningState
