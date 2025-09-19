// Bicep template for Log Analytics custom table: ProofpointPOD_message_CL
// Generated on 2025-09-19 14:13:57 UTC
// Source: JSON schema export
// Original columns: 110, Deployed columns: 110 (Type column filtered)
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

resource proofpointpodmessageclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'ProofpointPOD_message_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'ProofpointPOD_message_CL'
      description: 'Custom table ProofpointPOD_message_CL - imported from JSON schema'
      displayName: 'ProofpointPOD_message_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'EventVendor'
          type: 'string'
        }
        {
          name: 'envelope_from_s'
          type: 'string'
        }
        {
          name: 'envelope_fromHashed_s'
          type: 'string'
        }
        {
          name: 'envelope_rcpts_s'
          type: 'string'
        }
        {
          name: 'envelope_rcptsHashed_s'
          type: 'string'
        }
        {
          name: 'guid_s'
          type: 'string'
        }
        {
          name: 'filter_verified_rcpts_s'
          type: 'string'
        }
        {
          name: 'filter_verified_rcptsHashed_s'
          type: 'string'
        }
        {
          name: 'filter_msgSizeBytes_d'
          type: 'real'
        }
        {
          name: 'filter_suborgs_sender_s'
          type: 'string'
        }
        {
          name: 'filter_suborgs_rcpts_s'
          type: 'string'
        }
        {
          name: 'filter_disposition_s'
          type: 'string'
        }
        {
          name: 'filter_modules_zerohour_score_s'
          type: 'string'
        }
        {
          name: 'filter_modules_pdr_v2_response_s'
          type: 'string'
        }
        {
          name: 'filter_modules_dkimv_s'
          type: 'string'
        }
        {
          name: 'filter_modules_urldefense_counts_total_d'
          type: 'real'
        }
        {
          name: 'filter_modules_urldefense_counts_rewritten_d'
          type: 'real'
        }
        {
          name: 'filter_modules_urldefense_counts_unique_d'
          type: 'real'
        }
        {
          name: 'filter_modules_urldefense_version_engine_s'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'filter_modules_spam_langs_s'
          type: 'string'
        }
        {
          name: 'filter_modules_spam_scores_classifiers_s'
          type: 'string'
        }
        {
          name: 'filter_modules_spam_scores_engine_d'
          type: 'real'
        }
        {
          name: 'filter_modules_spam_scores_overall_d'
          type: 'real'
        }
        {
          name: 'filter_modules_spam_version_definitions_s'
          type: 'string'
        }
        {
          name: 'event_type_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_return_pathHashed_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_x_mailer_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_return_path_s'
          type: 'string'
        }
        {
          name: 'filter_modules_urldefense_counts_noRewriteIsSchemeless_d'
          type: 'real'
        }
        {
          name: 'filter_modules_urldefense_counts_noRewriteIsUnsupportedScheme_d'
          type: 'real'
        }
        {
          name: 'filter_throttleIp_s'
          type: 'string'
        }
        {
          name: 'filter_modules_av_virusNames_s'
          type: 'string'
        }
        {
          name: 'msg_header_cc_s'
          type: 'string'
        }
        {
          name: 'msg_header_ccHashed_s'
          type: 'string'
        }
        {
          name: 'msg_parsedAddresses_cc_s'
          type: 'string'
        }
        {
          name: 'msg_parsedAddresses_ccHashed_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_ccHashed_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_cc_s'
          type: 'string'
        }
        {
          name: 'filter_origGuid_s'
          type: 'string'
        }
        {
          name: 'filter_modules_spam_version_engine_s'
          type: 'string'
        }
        {
          name: 'filter_modules_pdr_v2_rscore_d'
          type: 'real'
        }
        {
          name: 'msg_header_reply_to_s'
          type: 'string'
        }
        {
          name: 'msg_header_reply_toHashed_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_reply_toHashed_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_reply_to_s'
          type: 'string'
        }
        {
          name: 'msg_header_x_originating_ip_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_x_originating_ip_s'
          type: 'string'
        }
        {
          name: 'filter_modules_dmarc_alignment_s'
          type: 'string'
        }
        {
          name: 'filter_modules_spam_charsets_s'
          type: 'string'
        }
        {
          name: 'msg_header_return_path_s'
          type: 'string'
        }
        {
          name: 'msg_header_return_pathHashed_s'
          type: 'string'
        }
        {
          name: 'msg_header_x_mailer_s'
          type: 'string'
        }
        {
          name: 'filter_modules_urldefense_counts_noRewriteIsEmail_d'
          type: 'real'
        }
        {
          name: 'filter_modules_urldefense_counts_noRewriteIsMaxLengthExceeded_d'
          type: 'real'
        }
        {
          name: 'filter_modules_spam_safeBlockedListMatches_s'
          type: 'string'
        }
        {
          name: 'filter_modules_spf_result_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_subject_s'
          type: 'string'
        }
        {
          name: 'msg_lang_s'
          type: 'string'
        }
        {
          name: 'msg_sizeBytes_d'
          type: 'real'
        }
        {
          name: 'connection_resolveStatus_s'
          type: 'string'
        }
        {
          name: 'connection_protocol_s'
          type: 'string'
        }
        {
          name: 'connection_helo_s'
          type: 'string'
        }
        {
          name: 'connection_country_s'
          type: 'string'
        }
        {
          name: 'connection_host_s'
          type: 'string'
        }
        {
          name: 'connection_sid_s'
          type: 'string'
        }
        {
          name: 'connection_ip_s'
          type: 'string'
        }
        {
          name: 'connection_tls_inbound_version_s'
          type: 'string'
        }
        {
          name: 'connection_tls_inbound_cipherBits_d'
          type: 'real'
        }
        {
          name: 'connection_tls_inbound_cipher_s'
          type: 'string'
        }
        {
          name: 'ts_t'
          type: 'dateTime'
        }
        {
          name: 'metadata_origin_data_cid_s'
          type: 'string'
        }
        {
          name: 'metadata_origin_data_version_s'
          type: 'string'
        }
        {
          name: 'metadata_origin_data_agent_s'
          type: 'string'
        }
        {
          name: 'msgParts_s'
          type: 'string'
        }
        {
          name: 'pps_cid_s'
          type: 'string'
        }
        {
          name: 'pps_version_s'
          type: 'string'
        }
        {
          name: 'pps_agent_s'
          type: 'string'
        }
        {
          name: 'filter_modules_urldefense_counts_noRewriteIsLargeMsgPartSize_d'
          type: 'real'
        }
        {
          name: 'EventProduct'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_message_id_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_to_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_toHashed_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_from_s'
          type: 'string'
        }
        {
          name: 'filter_modules_spf_domain_s'
          type: 'string'
        }
        {
          name: 'filter_modules_dmarc_authResults_s'
          type: 'string'
        }
        {
          name: 'filter_modules_dmarc_filterdResult_s'
          type: 'string'
        }
        {
          name: 'filter_modules_dmarc_records_s'
          type: 'string'
        }
        {
          name: 'filter_modules_dmarc_srvid_s'
          type: 'string'
        }
        {
          name: 'filter_quarantine_folder_s'
          type: 'string'
        }
        {
          name: 'filter_quarantine_rule_s'
          type: 'string'
        }
        {
          name: 'filter_routeDirection_s'
          type: 'string'
        }
        {
          name: 'filter_startTime_t'
          type: 'dateTime'
        }
        {
          name: 'filter_qid_s'
          type: 'string'
        }
        {
          name: 'filter_routes_s'
          type: 'string'
        }
        {
          name: 'filter_modules_spam_triggeredClassifier_s'
          type: 'string'
        }
        {
          name: 'filter_actions_s'
          type: 'string'
        }
        {
          name: 'msg_parsedAddresses_to_s'
          type: 'string'
        }
        {
          name: 'msg_parsedAddresses_toHashed_s'
          type: 'string'
        }
        {
          name: 'msg_parsedAddresses_from_s'
          type: 'string'
        }
        {
          name: 'msg_parsedAddresses_fromHashed_s'
          type: 'string'
        }
        {
          name: 'msg_header_toHashed_s'
          type: 'string'
        }
        {
          name: 'msg_header_to_s'
          type: 'string'
        }
        {
          name: 'msg_header_subject_s'
          type: 'string'
        }
        {
          name: 'msg_header_message_id_s'
          type: 'string'
        }
        {
          name: 'msg_header_fromHashed_s'
          type: 'string'
        }
        {
          name: 'msg_header_from_s'
          type: 'string'
        }
        {
          name: 'msg_normalizedHeader_fromHashed_s'
          type: 'string'
        }
        {
          name: 'filter_durationSecs_d'
          type: 'real'
        }
        {
          name: 'filter_modules_urldefense_counts_noRewriteIsExcludedDomain_d'
          type: 'real'
        }
      ]
    }
  }
}

output tableName string = proofpointpodmessageclTable.name
output tableId string = proofpointpodmessageclTable.id
output provisioningState string = proofpointpodmessageclTable.properties.provisioningState
