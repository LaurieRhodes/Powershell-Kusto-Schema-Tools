// Bicep template for Log Analytics custom table: CitrixAnalytics_indicatorEventDetails_CL
// Generated on 2025-09-19 14:13:51 UTC
// Source: JSON schema export
// Original columns: 89, Deployed columns: 88 (Type column filtered)
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

resource citrixanalyticsindicatoreventdetailsclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'CitrixAnalytics_indicatorEventDetails_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'CitrixAnalytics_indicatorEventDetails_CL'
      description: 'Custom table CitrixAnalytics_indicatorEventDetails_CL - imported from JSON schema'
      displayName: 'CitrixAnalytics_indicatorEventDetails_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
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
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'os_extra_info_s'
          type: 'string'
        }
        {
          name: 'lifetime_total_download_size_in_bytes_d'
          type: 'real'
        }
        {
          name: 'lifetime_first_event_time_t'
          type: 'dateTime'
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
          type: 'real'
        }
        {
          name: 'indicator_vector_id_d'
          type: 'real'
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
          type: 'real'
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
          dataTypeHint: 0
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
          type: 'real'
        }
        {
          name: 'device_browser_s'
          type: 'string'
        }
        {
          name: 'data_source_id_d'
          type: 'real'
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
          dataTypeHint: 0
        }
        {
          name: 'app_name_s'
          type: 'string'
        }
        {
          name: 'version_d'
          type: 'real'
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
          type: 'real'
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
}

output tableName string = citrixanalyticsindicatoreventdetailsclTable.name
output tableId string = citrixanalyticsindicatoreventdetailsclTable.id
output provisioningState string = citrixanalyticsindicatoreventdetailsclTable.properties.provisioningState
