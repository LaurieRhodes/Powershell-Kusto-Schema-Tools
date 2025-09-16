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
// Data Collection Rule for Corelight_v2_rfb_CL
// ============================================================================
// Generated: 2025-09-17 06:20:50
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 20, DCR columns: 20 (Type column always filtered)
// Output stream: Custom-Corelight_v2_rfb_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-Corelight_v2_rfb_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-Corelight_v2_rfb_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: '_path_s'
            type: 'string'
          }
          {
            name: 'desktop_name_s'
            type: 'string'
          }
          {
            name: 'share_flag_b'
            type: 'string'
          }
          {
            name: 'auth_b'
            type: 'string'
          }
          {
            name: 'authentication_method_s'
            type: 'string'
          }
          {
            name: 'server_minor_version_s'
            type: 'string'
          }
          {
            name: 'server_major_version_s'
            type: 'string'
          }
          {
            name: 'client_minor_version_s'
            type: 'string'
          }
          {
            name: 'width_d'
            type: 'string'
          }
          {
            name: 'client_major_version_s'
            type: 'string'
          }
          {
            name: 'id_resp_h_s'
            type: 'string'
          }
          {
            name: 'id_orig_p_d'
            type: 'string'
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
            type: 'string'
          }
          {
            name: '_write_ts_t'
            type: 'string'
          }
          {
            name: '_system_name_s'
            type: 'string'
          }
          {
            name: 'id_resp_p_d'
            type: 'string'
          }
          {
            name: 'height_d'
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
          name: 'Sentinel-Corelight_v2_rfb_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-Corelight_v2_rfb_CL']
        destinations: ['Sentinel-Corelight_v2_rfb_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), _path_s = tostring(_path_s), desktop_name_s = tostring(desktop_name_s), share_flag_b = tobool(share_flag_b), auth_b = tobool(auth_b), authentication_method_s = tostring(authentication_method_s), server_minor_version_s = tostring(server_minor_version_s), server_major_version_s = tostring(server_major_version_s), client_minor_version_s = tostring(client_minor_version_s), width_d = toreal(width_d), client_major_version_s = tostring(client_major_version_s), id_resp_h_s = tostring(id_resp_h_s), id_orig_p_d = toreal(id_orig_p_d), id_orig_h_s = tostring(id_orig_h_s), uid_s = tostring(uid_s), ts_t = todatetime(ts_t), _write_ts_t = todatetime(_write_ts_t), _system_name_s = tostring(_system_name_s), id_resp_p_d = toreal(id_resp_p_d), height_d = toreal(height_d)'
        outputStream: 'Custom-Corelight_v2_rfb_CL'
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
