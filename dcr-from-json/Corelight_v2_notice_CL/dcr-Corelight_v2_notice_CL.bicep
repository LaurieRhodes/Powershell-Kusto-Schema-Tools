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
// Data Collection Rule for Corelight_v2_notice_CL
// ============================================================================
// Generated: 2025-09-17 06:20:50
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 31, DCR columns: 31 (Type column always filtered)
// Output stream: Custom-Corelight_v2_notice_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-Corelight_v2_notice_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-Corelight_v2_notice_CL': {
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
            name: 'remote_location_longitude_d'
            type: 'string'
          }
          {
            name: 'remote_location_latitude_d'
            type: 'string'
          }
          {
            name: 'remote_location_city_s'
            type: 'string'
          }
          {
            name: 'remote_location_region_s'
            type: 'string'
          }
          {
            name: 'remote_location_country_code_s'
            type: 'string'
          }
          {
            name: 'suppress_for_d'
            type: 'string'
          }
          {
            name: 'actions_s'
            type: 'string'
          }
          {
            name: 'peer_descr_s'
            type: 'string'
          }
          {
            name: 'n_d'
            type: 'string'
          }
          {
            name: 'p_d'
            type: 'string'
          }
          {
            name: 'dst_s'
            type: 'string'
          }
          {
            name: 'src_s'
            type: 'string'
          }
          {
            name: 'sub_s'
            type: 'string'
          }
          {
            name: 'msg_s'
            type: 'string'
          }
          {
            name: 'note_s'
            type: 'string'
          }
          {
            name: 'proto_s'
            type: 'string'
          }
          {
            name: 'file_desc_s'
            type: 'string'
          }
          {
            name: 'file_mime_type_s'
            type: 'string'
          }
          {
            name: 'fuid_s'
            type: 'string'
          }
          {
            name: 'id_resp_p_d'
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
            name: 'severity_level_d'
            type: 'string'
          }
          {
            name: 'severity_name_s'
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
          name: 'Sentinel-Corelight_v2_notice_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-Corelight_v2_notice_CL']
        destinations: ['Sentinel-Corelight_v2_notice_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), _path_s = tostring(_path_s), remote_location_longitude_d = toreal(remote_location_longitude_d), remote_location_latitude_d = toreal(remote_location_latitude_d), remote_location_city_s = tostring(remote_location_city_s), remote_location_region_s = tostring(remote_location_region_s), remote_location_country_code_s = tostring(remote_location_country_code_s), suppress_for_d = toreal(suppress_for_d), actions_s = tostring(actions_s), peer_descr_s = tostring(peer_descr_s), n_d = toreal(n_d), p_d = toreal(p_d), dst_s = tostring(dst_s), src_s = tostring(src_s), sub_s = tostring(sub_s), msg_s = tostring(msg_s), note_s = tostring(note_s), proto_s = tostring(proto_s), file_desc_s = tostring(file_desc_s), file_mime_type_s = tostring(file_mime_type_s), fuid_s = tostring(fuid_s), id_resp_p_d = toreal(id_resp_p_d), id_resp_h_s = tostring(id_resp_h_s), id_orig_p_d = toreal(id_orig_p_d), id_orig_h_s = tostring(id_orig_h_s), uid_s = tostring(uid_s), ts_t = todatetime(ts_t), _write_ts_t = todatetime(_write_ts_t), _system_name_s = tostring(_system_name_s), severity_level_d = toreal(severity_level_d), severity_name_s = tostring(severity_name_s)'
        outputStream: 'Custom-Corelight_v2_notice_CL'
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
