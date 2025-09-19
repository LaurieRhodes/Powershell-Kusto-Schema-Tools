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
// Data Collection Rule for CiscoSecureEndpoint_CL
// ============================================================================
// Generated: 2025-09-19 14:20:00
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns filtered out
// Original columns: 86, DCR columns: 83 (Type column always filtered)
// Output stream: Custom-CiscoSecureEndpoint_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-CiscoSecureEndpoint_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-CiscoSecureEndpoint_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: 'audit_log_id_g'
            type: 'string'
          }
          {
            name: 'new_attributes_status_s'
            type: 'string'
          }
          {
            name: 'new_attributes_product_version_id_d'
            type: 'string'
          }
          {
            name: 'new_attributes_policy_id_d'
            type: 'string'
          }
          {
            name: 'new_attributes_operating_system_id_d'
            type: 'string'
          }
          {
            name: 'new_attributes_name_s'
            type: 'string'
          }
          {
            name: 'new_attributes_ip_external_s'
            type: 'string'
          }
          {
            name: 'new_attributes_hostname_s'
            type: 'string'
          }
          {
            name: 'old_attributes_hostname_s'
            type: 'string'
          }
          {
            name: 'new_attributes_group_id_d'
            type: 'string'
          }
          {
            name: 'id_d'
            type: 'string'
          }
          {
            name: 'hostname_s'
            type: 'string'
          }
          {
            name: 'group_guids_s'
            type: 'string'
          }
          {
            name: 'file_parent_process_id_s'
            type: 'string'
          }
          {
            name: 'file_parent_process_id_d'
            type: 'string'
          }
          {
            name: 'file_parent_identity_sha256_s'
            type: 'string'
          }
          {
            name: 'file_parent_identity_sha1_s'
            type: 'string'
          }
          {
            name: 'new_attributes_connector_guid_g'
            type: 'string'
          }
          {
            name: 'old_attributes_ip_external_s'
            type: 'string'
          }
          {
            name: 'old_attributes_name_s'
            type: 'string'
          }
          {
            name: 'old_attributes_operating_system_id_d'
            type: 'string'
          }
          {
            name: 'timestamp_d'
            type: 'string'
          }
          {
            name: 'techniques_s'
            type: 'string'
          }
          {
            name: 'tactics_s'
            type: 'string'
          }
          {
            name: 'start_timestamp_d'
            type: 'string'
          }
          {
            name: 'start_date_t'
            type: 'string'
          }
          {
            name: 'severity_s'
            type: 'string'
          }
          {
            name: 'scan_scanned_processes_d'
            type: 'string'
          }
          {
            name: 'scan_scanned_paths_d'
            type: 'string'
          }
          {
            name: 'scan_scanned_files_d'
            type: 'string'
          }
          {
            name: 'scan_malicious_detections_d'
            type: 'string'
          }
          {
            name: 'scan_description_s'
            type: 'string'
          }
          {
            name: 'scan_clean_b'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
          {
            name: 'orbital_version_s'
            type: 'string'
          }
          {
            name: 'orbital_old_version_s'
            type: 'string'
          }
          {
            name: 'old_attributes_status_s'
            type: 'string'
          }
          {
            name: 'old_attributes_product_version_id_d'
            type: 'string'
          }
          {
            name: 'file_parent_identity_md5_g'
            type: 'string'
          }
          {
            name: 'file_parent_file_name_s'
            type: 'string'
          }
          {
            name: 'file_parent_disposition_s'
            type: 'string'
          }
          {
            name: 'file_identity_sha256_s'
            type: 'string'
          }
          {
            name: 'computer_links_trajectory_s'
            type: 'string'
          }
          {
            name: 'computer_links_group_s'
            type: 'string'
          }
          {
            name: 'computer_links_computer_s'
            type: 'string'
          }
          {
            name: 'computer_hostname_s'
            type: 'string'
          }
          {
            name: 'computer_external_ip_s'
            type: 'string'
          }
          {
            name: 'computer_connector_guid_g'
            type: 'string'
          }
          {
            name: 'computer_active_b'
            type: 'string'
          }
          {
            name: 'Computer'
            type: 'string'
          }
          {
            name: 'command_line_arguments_s'
            type: 'string'
          }
          {
            name: 'cloud_ioc_short_description_s'
            type: 'string'
          }
          {
            name: 'cloud_ioc_description_s'
            type: 'string'
          }
          {
            name: 'bp_data_sts_d'
            type: 'string'
          }
          {
            name: 'bp_data_package_manager_serial_number_d'
            type: 'string'
          }
          {
            name: 'bp_data_package_manager_pending_version_d'
            type: 'string'
          }
          {
            name: 'audit_log_user_s'
            type: 'string'
          }
          {
            name: 'audit_log_type_s'
            type: 'string'
          }
          {
            name: 'audit_log_id_s'
            type: 'string'
          }
          {
            name: 'computer_network_addresses_s'
            type: 'string'
          }
          {
            name: 'timestamp_nanoseconds_d'
            type: 'string'
          }
          {
            name: 'computer_user_s'
            type: 'string'
          }
          {
            name: 'created_at_t'
            type: 'string'
          }
          {
            name: 'file_identity_sha1_s'
            type: 'string'
          }
          {
            name: 'file_identity_md5_g'
            type: 'string'
          }
          {
            name: 'file_file_path_s'
            type: 'string'
          }
          {
            name: 'file_file_name_s'
            type: 'string'
          }
          {
            name: 'file_disposition_s'
            type: 'string'
          }
          {
            name: 'file_attack_details_suspicious_files_s'
            type: 'string'
          }
          {
            name: 'file_attack_details_base_address_s'
            type: 'string'
          }
          {
            name: 'file_attack_details_attacked_module_s'
            type: 'string'
          }
          {
            name: 'file_attack_details_application_s'
            type: 'string'
          }
          {
            name: 'event_type_s'
            type: 'string'
          }
          {
            name: 'event_type_id_d'
            type: 'string'
          }
          {
            name: 'event_s'
            type: 'string'
          }
          {
            name: 'error_error_code_d'
            type: 'string'
          }
          {
            name: 'error_description_s'
            type: 'string'
          }
          {
            name: 'detection_s'
            type: 'string'
          }
          {
            name: 'detection_id_s'
            type: 'string'
          }
          {
            name: 'date_t'
            type: 'string'
          }
          {
            name: 'connector_guid_g'
            type: 'string'
          }
          {
            name: 'vulnerabilities_s'
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
          name: 'Sentinel-CiscoSecureEndpoint_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-CiscoSecureEndpoint_CL']
        destinations: ['Sentinel-CiscoSecureEndpoint_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), audit_log_id_g = tostring(audit_log_id_g), new_attributes_status_s = tostring(new_attributes_status_s), new_attributes_product_version_id_d = toreal(new_attributes_product_version_id_d), new_attributes_policy_id_d = toreal(new_attributes_policy_id_d), new_attributes_operating_system_id_d = toreal(new_attributes_operating_system_id_d), new_attributes_name_s = tostring(new_attributes_name_s), new_attributes_ip_external_s = tostring(new_attributes_ip_external_s), new_attributes_hostname_s = tostring(new_attributes_hostname_s), old_attributes_hostname_s = tostring(old_attributes_hostname_s), new_attributes_group_id_d = toreal(new_attributes_group_id_d), id_d = toreal(id_d), hostname_s = tostring(hostname_s), group_guids_s = tostring(group_guids_s), file_parent_process_id_s = tostring(file_parent_process_id_s), file_parent_process_id_d = toreal(file_parent_process_id_d), file_parent_identity_sha256_s = tostring(file_parent_identity_sha256_s), file_parent_identity_sha1_s = tostring(file_parent_identity_sha1_s), new_attributes_connector_guid_g = tostring(new_attributes_connector_guid_g), old_attributes_ip_external_s = tostring(old_attributes_ip_external_s), old_attributes_name_s = tostring(old_attributes_name_s), old_attributes_operating_system_id_d = toreal(old_attributes_operating_system_id_d), timestamp_d = toreal(timestamp_d), techniques_s = tostring(techniques_s), tactics_s = tostring(tactics_s), start_timestamp_d = toreal(start_timestamp_d), start_date_t = todatetime(start_date_t), severity_s = tostring(severity_s), scan_scanned_processes_d = toreal(scan_scanned_processes_d), scan_scanned_paths_d = toreal(scan_scanned_paths_d), scan_scanned_files_d = toreal(scan_scanned_files_d), scan_malicious_detections_d = toreal(scan_malicious_detections_d), scan_description_s = tostring(scan_description_s), scan_clean_b = tobool(scan_clean_b), RawData = tostring(RawData), orbital_version_s = tostring(orbital_version_s), orbital_old_version_s = tostring(orbital_old_version_s), old_attributes_status_s = tostring(old_attributes_status_s), old_attributes_product_version_id_d = toreal(old_attributes_product_version_id_d), file_parent_identity_md5_g = tostring(file_parent_identity_md5_g), file_parent_file_name_s = tostring(file_parent_file_name_s), file_parent_disposition_s = tostring(file_parent_disposition_s), file_identity_sha256_s = tostring(file_identity_sha256_s), computer_links_trajectory_s = tostring(computer_links_trajectory_s), computer_links_group_s = tostring(computer_links_group_s), computer_links_computer_s = tostring(computer_links_computer_s), computer_hostname_s = tostring(computer_hostname_s), computer_external_ip_s = tostring(computer_external_ip_s), computer_connector_guid_g = tostring(computer_connector_guid_g), computer_active_b = tobool(computer_active_b), Computer = tostring(Computer), command_line_arguments_s = tostring(command_line_arguments_s), cloud_ioc_short_description_s = tostring(cloud_ioc_short_description_s), cloud_ioc_description_s = tostring(cloud_ioc_description_s), bp_data_sts_d = toreal(bp_data_sts_d), bp_data_package_manager_serial_number_d = toreal(bp_data_package_manager_serial_number_d), bp_data_package_manager_pending_version_d = toreal(bp_data_package_manager_pending_version_d), audit_log_user_s = tostring(audit_log_user_s), audit_log_type_s = tostring(audit_log_type_s), audit_log_id_s = tostring(audit_log_id_s), computer_network_addresses_s = tostring(computer_network_addresses_s), timestamp_nanoseconds_d = toreal(timestamp_nanoseconds_d), computer_user_s = tostring(computer_user_s), created_at_t = todatetime(created_at_t), file_identity_sha1_s = tostring(file_identity_sha1_s), file_identity_md5_g = tostring(file_identity_md5_g), file_file_path_s = tostring(file_file_path_s), file_file_name_s = tostring(file_file_name_s), file_disposition_s = tostring(file_disposition_s), file_attack_details_suspicious_files_s = tostring(file_attack_details_suspicious_files_s), file_attack_details_base_address_s = tostring(file_attack_details_base_address_s), file_attack_details_attacked_module_s = tostring(file_attack_details_attacked_module_s), file_attack_details_application_s = tostring(file_attack_details_application_s), event_type_s = tostring(event_type_s), event_type_id_d = toreal(event_type_id_d), event_s = tostring(event_s), error_error_code_d = toreal(error_error_code_d), error_description_s = tostring(error_description_s), detection_s = tostring(detection_s), detection_id_s = tostring(detection_id_s), date_t = todatetime(date_t), connector_guid_g = tostring(connector_guid_g), vulnerabilities_s = tostring(vulnerabilities_s)'
        outputStream: 'Custom-CiscoSecureEndpoint_CL'
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
