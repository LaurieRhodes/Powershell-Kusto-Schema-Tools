// Bicep template for Log Analytics custom table: CiscoSecureEndpoint_CL
// Generated on 2025-09-17 06:39:58 UTC
// Source: JSON schema export
// Original columns: 86, Deployed columns: 85 (Type column filtered)
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

resource ciscosecureendpointclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'CiscoSecureEndpoint_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'CiscoSecureEndpoint_CL'
      description: 'Custom table CiscoSecureEndpoint_CL - imported from JSON schema'
      displayName: 'CiscoSecureEndpoint_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'audit_log_id_g'
          type: 'string'
        }
        {
          name: 'old_attributes_ip_external_s'
          type: 'string'
        }
        {
          name: 'old_attributes_hostname_s'
          type: 'string'
        }
        {
          name: 'new_attributes_status_s'
          type: 'string'
        }
        {
          name: 'new_attributes_product_version_id_d'
          type: 'real'
        }
        {
          name: 'new_attributes_policy_id_d'
          type: 'real'
        }
        {
          name: 'new_attributes_operating_system_id_d'
          type: 'real'
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
          name: 'new_attributes_group_id_d'
          type: 'real'
        }
        {
          name: 'new_attributes_connector_guid_g'
          type: 'string'
        }
        {
          name: 'id_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'file_parent_identity_sha256_s'
          type: 'string'
        }
        {
          name: 'old_attributes_name_s'
          type: 'string'
        }
        {
          name: 'file_parent_identity_sha1_s'
          type: 'string'
        }
        {
          name: 'old_attributes_operating_system_id_d'
          type: 'real'
        }
        {
          name: 'old_attributes_status_s'
          type: 'string'
        }
        {
          name: 'vulnerabilities_s'
          type: 'string'
        }
        {
          name: 'timestamp_nanoseconds_d'
          type: 'real'
        }
        {
          name: 'timestamp_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'start_date_t'
          type: 'dateTime'
        }
        {
          name: 'severity_s'
          type: 'string'
        }
        {
          name: 'scan_scanned_processes_d'
          type: 'real'
        }
        {
          name: 'scan_scanned_paths_d'
          type: 'real'
        }
        {
          name: 'scan_scanned_files_d'
          type: 'real'
        }
        {
          name: 'scan_malicious_detections_d'
          type: 'real'
        }
        {
          name: 'scan_description_s'
          type: 'string'
        }
        {
          name: 'scan_clean_b'
          type: 'boolean'
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
          name: 'old_attributes_product_version_id_d'
          type: 'real'
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
          name: 'computer_links_trajectory_s'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'computer_links_group_s'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'computer_links_computer_s'
          type: 'string'
          dataTypeHint: 0
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
          type: 'boolean'
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
          type: 'real'
        }
        {
          name: 'bp_data_package_manager_serial_number_d'
          type: 'real'
        }
        {
          name: 'bp_data_package_manager_pending_version_d'
          type: 'real'
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
          name: 'computer_user_s'
          type: 'string'
        }
        {
          name: 'connector_guid_g'
          type: 'string'
        }
        {
          name: 'created_at_t'
          type: 'dateTime'
        }
        {
          name: 'file_identity_sha256_s'
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
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: 'file_attack_details_attacked_module_s'
          type: 'string'
        }
        {
          name: 'event_type_s'
          type: 'string'
        }
        {
          name: 'event_type_id_d'
          type: 'real'
        }
        {
          name: 'event_s'
          type: 'string'
        }
        {
          name: 'error_error_code_d'
          type: 'real'
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
          type: 'dateTime'
        }
        {
          name: 'file_attack_details_application_s'
          type: 'string'
        }
        {
          name: '_SubscriptionId'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = ciscosecureendpointclTable.name
output tableId string = ciscosecureendpointclTable.id
output provisioningState string = ciscosecureendpointclTable.properties.provisioningState
