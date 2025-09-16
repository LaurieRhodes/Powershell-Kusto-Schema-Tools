@description('The location of the resources')
param location string = 'Australia East'
@description('The name of the Data Collection Endpoint Id')
param dataCollectionEndpointId string
@description('The Log Analytics Workspace Id used for Sentinel')
param workspaceResourceId string
@description('The Target Sentinel workspace name')
param workspaceName string = 'sentinel-workspace'
@description('The Service Principal Object ID of the Entra App')
param servicePrincipalObjectId string

// ============================================================================
// Data Collection Rule for CynerioEvent_CL
// ============================================================================
// Generated: 2025-09-17 06:20:53
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 39, DCR columns: 38 (Type column always filtered)
// Output stream: Custom-CynerioEvent_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-CynerioEvent_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-CynerioEvent_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: 'TenantId'
            type: 'string'
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
            name: 'client_ip_s'
            type: 'string'
          }
          {
            name: 'details_s'
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
            type: 'string'
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
            name: 'timestamp_d'
            type: 'string'
          }
          {
            name: 'asset_asset_type_code_s'
            type: 'string'
          }
          {
            name: 'title_s'
            type: 'string'
          }
          {
            name: 'status_code_s'
            type: 'string'
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
            type: 'string'
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
            name: 'Severity'
            type: 'string'
          }
          {
            name: '_ResourceId'
            type: 'string'
          }
        ]
      }
    }
    dataSources: {}
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'Sentinel-CynerioEvent_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-CynerioEvent_CL']
        destinations: ['Sentinel-CynerioEvent_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), asset_id_g = tostring(asset_id_g), asset_ip_s = tostring(asset_ip_s), asset_model_s = tostring(asset_model_s), asset_name_s = tostring(asset_name_s), asset_type_s = tostring(asset_type_s), asset_type_code_s = tostring(asset_type_code_s), client_ip_s = tostring(client_ip_s), details_s = tostring(details_s), id_g = tostring(id_g), module_s = tostring(module_s), port_d = toreal(port_d), related_risks_s = tostring(related_risks_s), server_ip_s = tostring(server_ip_s), severity_s = tostring(severity_s), timestamp_d = toreal(timestamp_d), asset_asset_type_code_s = tostring(asset_asset_type_code_s), title_s = tostring(title_s), status_code_s = tostring(status_code_s), host_s = tostring(host_s), SourceSystem = tostring(SourceSystem), MG = tostring(MG), ManagementGroupName = tostring(ManagementGroupName), Computer = tostring(Computer), RawData = tostring(RawData), date_t = todatetime(date_t), asset_id_s = tostring(asset_id_s), dst_ip_s = tostring(dst_ip_s), src_ip_s = tostring(src_ip_s), trans_s = tostring(trans_s), uid_s = tostring(uid_s), service_s = tostring(service_s), new_status_s = tostring(new_status_s), risk_name_s = tostring(risk_name_s), browser_s = tostring(browser_s), Severity = toint(Severity), _ResourceId = tostring(_ResourceId)'
        outputStream: 'Custom-CynerioEvent_CL'
      }
    ]
  }
}

// Role Assignment to the DCR
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: dataCollectionRule
  name: guid(resourceGroup().id, roleDefinitionResourceId, dataCollectionRule.name)
  properties: {
    roleDefinitionId: roleDefinitionResourceId
    principalId: servicePrincipalObjectId
    principalType: 'ServicePrincipal'
  }
}

output immutableId string = dataCollectionRule.properties.immutableId
output dataCollectionRuleId string = dataCollectionRule.id
output dataCollectionRuleName string = dataCollectionRule.name
