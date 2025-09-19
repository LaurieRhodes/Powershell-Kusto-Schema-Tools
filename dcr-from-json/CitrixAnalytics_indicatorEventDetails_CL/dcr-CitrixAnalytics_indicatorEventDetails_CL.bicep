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
// Data Collection Rule for CitrixAnalytics_indicatorEventDetails_CL
// ============================================================================
// Generated: 2025-09-19 14:20:00
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns filtered out
// Original columns: 89, DCR columns: 88 (Type column always filtered)
// Output stream: Custom-CitrixAnalytics_indicatorEventDetails_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-CitrixAnalytics_indicatorEventDetails_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-CitrixAnalytics_indicatorEventDetails_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: 'entity_id_s'
            type: 'string'
          }
          {
            name: 'os_extra_details_s'
            type: 'string'
          }
          {
            name: 'operation_name_s'
            type: 'string'
          }
          {
            name: 'occurrence_event_type_s'
            type: 'string'
          }
          {
            name: 'nth_failure_d'
            type: 'string'
          }
          {
            name: 'module_file_path_s'
            type: 'string'
          }
          {
            name: 'longitude_s'
            type: 'string'
          }
          {
            name: 'lifetime_unique_user_emails_s'
            type: 'string'
          }
          {
            name: 'lifetime_unique_user_count_d'
            type: 'string'
          }
          {
            name: 'os_extra_info_s'
            type: 'string'
          }
          {
            name: 'lifetime_total_download_size_in_bytes_d'
            type: 'string'
          }
          {
            name: 'lifetime_first_event_time_t'
            type: 'string'
          }
          {
            name: 'launch_type_s'
            type: 'string'
          }
          {
            name: 'latitude_s'
            type: 'string'
          }
          {
            name: 'job_details_size_in_bytes_s'
            type: 'string'
          }
          {
            name: 'job_details_format_s'
            type: 'string'
          }
          {
            name: 'job_details_filename_s'
            type: 'string'
          }
          {
            name: 'is_risky_s'
            type: 'string'
          }
          {
            name: 'indicator_vector_name_s'
            type: 'string'
          }
          {
            name: 'lifetime_num_times_downloaded_d'
            type: 'string'
          }
          {
            name: 'indicator_vector_id_d'
            type: 'string'
          }
          {
            name: 'os_major_version_s'
            type: 'string'
          }
          {
            name: 'os_name_s'
            type: 'string'
          }
          {
            name: 'virus_name_s'
            type: 'string'
          }
          {
            name: 'user_email_s'
            type: 'string'
          }
          {
            name: 'transaction_count_d'
            type: 'string'
          }
          {
            name: 'tool_name_s'
            type: 'string'
          }
          {
            name: 'share_id_s'
            type: 'string'
          }
          {
            name: 'session_user_name_s'
            type: 'string'
          }
          {
            name: 'session_guid_s'
            type: 'string'
          }
          {
            name: 'server_name_s'
            type: 'string'
          }
          {
            name: 'os_minor_version_s'
            type: 'string'
          }
          {
            name: 'security_expression_s'
            type: 'string'
          }
          {
            name: 'resource_name_s'
            type: 'string'
          }
          {
            name: 'region_s'
            type: 'string'
          }
          {
            name: 'receiver_type_s'
            type: 'string'
          }
          {
            name: 'reason_for_action_s'
            type: 'string'
          }
          {
            name: 'product_s'
            type: 'string'
          }
          {
            name: 'printer_name_s'
            type: 'string'
          }
          {
            name: 'policy_name_s'
            type: 'string'
          }
          {
            name: 'os_version_s'
            type: 'string'
          }
          {
            name: 'resource_type_s'
            type: 'string'
          }
          {
            name: 'vpn_vserver_name_s'
            type: 'string'
          }
          {
            name: 'indicator_uuid_g'
            type: 'string'
          }
          {
            name: 'indicator_category_id_d'
            type: 'string'
          }
          {
            name: 'device_browser_s'
            type: 'string'
          }
          {
            name: 'data_source_id_d'
            type: 'string'
          }
          {
            name: 'cs_vserver_name_s'
            type: 'string'
          }
          {
            name: 'country_s'
            type: 'string'
          }
          {
            name: 'connector_type_s'
            type: 'string'
          }
          {
            name: 'component_name_s'
            type: 'string'
          }
          {
            name: 'client_ip_s'
            type: 'string'
          }
          {
            name: 'city_s'
            type: 'string'
          }
          {
            name: 'device_id_s'
            type: 'string'
          }
          {
            name: 'browser_s'
            type: 'string'
          }
          {
            name: 'authentication_type_s'
            type: 'string'
          }
          {
            name: 'authentication_stage_s'
            type: 'string'
          }
          {
            name: 'app_url_s'
            type: 'string'
          }
          {
            name: 'app_name_s'
            type: 'string'
          }
          {
            name: 'version_d'
            type: 'string'
          }
          {
            name: 'tenant_id_s'
            type: 'string'
          }
          {
            name: 'event_type_s'
            type: 'string'
          }
          {
            name: 'entity_type_s'
            type: 'string'
          }
          {
            name: 'auth_server_ip_s'
            type: 'string'
          }
          {
            name: 'indicator_id_s'
            type: 'string'
          }
          {
            name: 'device_os_s'
            type: 'string'
          }
          {
            name: 'domain_category_group_s'
            type: 'string'
          }
          {
            name: 'gateway_ip_s'
            type: 'string'
          }
          {
            name: 'gateway_domain_name_s'
            type: 'string'
          }
          {
            name: 'folder_name_s'
            type: 'string'
          }
          {
            name: 'file_type_s'
            type: 'string'
          }
          {
            name: 'file_size_in_bytes_d'
            type: 'string'
          }
          {
            name: 'file_path_s'
            type: 'string'
          }
          {
            name: 'file_name_s'
            type: 'string'
          }
          {
            name: 'file_hash_g'
            type: 'string'
          }
          {
            name: 'device_type_s'
            type: 'string'
          }
          {
            name: 'file_download_file_path_s'
            type: 'string'
          }
          {
            name: 'executed_action_s'
            type: 'string'
          }
          {
            name: 'event_id_s'
            type: 'string'
          }
          {
            name: 'event_description_s'
            type: 'string'
          }
          {
            name: 'entity_time_zone_s'
            type: 'string'
          }
          {
            name: 'domain_s'
            type: 'string'
          }
          {
            name: 'domain_reputation_d'
            type: 'string'
          }
          {
            name: 'domain_name_s'
            type: 'string'
          }
          {
            name: 'domain_category_s'
            type: 'string'
          }
          {
            name: 'file_download_file_name_s'
            type: 'string'
          }
          {
            name: 'vserver_fqdn_s'
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
          name: 'Sentinel-CitrixAnalytics_indicatorEventDetails_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-CitrixAnalytics_indicatorEventDetails_CL']
        destinations: ['Sentinel-CitrixAnalytics_indicatorEventDetails_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), entity_id_s = tostring(entity_id_s), os_extra_details_s = tostring(os_extra_details_s), operation_name_s = tostring(operation_name_s), occurrence_event_type_s = tostring(occurrence_event_type_s), nth_failure_d = toreal(nth_failure_d), module_file_path_s = tostring(module_file_path_s), longitude_s = tostring(longitude_s), lifetime_unique_user_emails_s = tostring(lifetime_unique_user_emails_s), lifetime_unique_user_count_d = toreal(lifetime_unique_user_count_d), os_extra_info_s = tostring(os_extra_info_s), lifetime_total_download_size_in_bytes_d = toreal(lifetime_total_download_size_in_bytes_d), lifetime_first_event_time_t = todatetime(lifetime_first_event_time_t), launch_type_s = tostring(launch_type_s), latitude_s = tostring(latitude_s), job_details_size_in_bytes_s = tostring(job_details_size_in_bytes_s), job_details_format_s = tostring(job_details_format_s), job_details_filename_s = tostring(job_details_filename_s), is_risky_s = tostring(is_risky_s), indicator_vector_name_s = tostring(indicator_vector_name_s), lifetime_num_times_downloaded_d = toreal(lifetime_num_times_downloaded_d), indicator_vector_id_d = toreal(indicator_vector_id_d), os_major_version_s = tostring(os_major_version_s), os_name_s = tostring(os_name_s), virus_name_s = tostring(virus_name_s), user_email_s = tostring(user_email_s), transaction_count_d = toreal(transaction_count_d), tool_name_s = tostring(tool_name_s), share_id_s = tostring(share_id_s), session_user_name_s = tostring(session_user_name_s), session_guid_s = tostring(session_guid_s), server_name_s = tostring(server_name_s), os_minor_version_s = tostring(os_minor_version_s), security_expression_s = tostring(security_expression_s), resource_name_s = tostring(resource_name_s), region_s = tostring(region_s), receiver_type_s = tostring(receiver_type_s), reason_for_action_s = tostring(reason_for_action_s), product_s = tostring(product_s), printer_name_s = tostring(printer_name_s), policy_name_s = tostring(policy_name_s), os_version_s = tostring(os_version_s), resource_type_s = tostring(resource_type_s), vpn_vserver_name_s = tostring(vpn_vserver_name_s), indicator_uuid_g = tostring(indicator_uuid_g), indicator_category_id_d = toreal(indicator_category_id_d), device_browser_s = tostring(device_browser_s), data_source_id_d = toreal(data_source_id_d), cs_vserver_name_s = tostring(cs_vserver_name_s), country_s = tostring(country_s), connector_type_s = tostring(connector_type_s), component_name_s = tostring(component_name_s), client_ip_s = tostring(client_ip_s), city_s = tostring(city_s), device_id_s = tostring(device_id_s), browser_s = tostring(browser_s), authentication_type_s = tostring(authentication_type_s), authentication_stage_s = tostring(authentication_stage_s), app_url_s = tostring(app_url_s), app_name_s = tostring(app_name_s), version_d = toreal(version_d), tenant_id_s = tostring(tenant_id_s), event_type_s = tostring(event_type_s), entity_type_s = tostring(entity_type_s), auth_server_ip_s = tostring(auth_server_ip_s), indicator_id_s = tostring(indicator_id_s), device_os_s = tostring(device_os_s), domain_category_group_s = tostring(domain_category_group_s), gateway_ip_s = tostring(gateway_ip_s), gateway_domain_name_s = tostring(gateway_domain_name_s), folder_name_s = tostring(folder_name_s), file_type_s = tostring(file_type_s), file_size_in_bytes_d = toreal(file_size_in_bytes_d), file_path_s = tostring(file_path_s), file_name_s = tostring(file_name_s), file_hash_g = tostring(file_hash_g), device_type_s = tostring(device_type_s), file_download_file_path_s = tostring(file_download_file_path_s), executed_action_s = tostring(executed_action_s), event_id_s = tostring(event_id_s), event_description_s = tostring(event_description_s), entity_time_zone_s = tostring(entity_time_zone_s), domain_s = tostring(domain_s), domain_reputation_d = tostring(domain_reputation_d), domain_name_s = tostring(domain_name_s), domain_category_s = tostring(domain_category_s), file_download_file_name_s = tostring(file_download_file_name_s), vserver_fqdn_s = tostring(vserver_fqdn_s)'
        outputStream: 'Custom-CitrixAnalytics_indicatorEventDetails_CL'
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
