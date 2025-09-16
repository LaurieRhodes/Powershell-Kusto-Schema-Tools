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
// Data Collection Rule for ProofpointPOD_message_CL
// ============================================================================
// Generated: 2025-09-17 06:21:01
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 110, DCR columns: 110 (Type column always filtered)
// Output stream: Custom-ProofpointPOD_message_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-ProofpointPOD_message_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-ProofpointPOD_message_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
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
            type: 'string'
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
            type: 'string'
          }
          {
            name: 'filter_modules_urldefense_counts_rewritten_d'
            type: 'string'
          }
          {
            name: 'filter_modules_urldefense_counts_unique_d'
            type: 'string'
          }
          {
            name: 'filter_modules_urldefense_version_engine_s'
            type: 'string'
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
            type: 'string'
          }
          {
            name: 'filter_modules_spam_scores_overall_d'
            type: 'string'
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
            type: 'string'
          }
          {
            name: 'filter_modules_urldefense_counts_noRewriteIsUnsupportedScheme_d'
            type: 'string'
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
            type: 'string'
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
            type: 'string'
          }
          {
            name: 'filter_modules_urldefense_counts_noRewriteIsMaxLengthExceeded_d'
            type: 'string'
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
            type: 'string'
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
            type: 'string'
          }
          {
            name: 'connection_tls_inbound_cipher_s'
            type: 'string'
          }
          {
            name: 'ts_t'
            type: 'string'
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
            type: 'string'
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
            type: 'string'
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
            type: 'string'
          }
          {
            name: 'filter_modules_urldefense_counts_noRewriteIsExcludedDomain_d'
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
          name: 'Sentinel-ProofpointPOD_message_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-ProofpointPOD_message_CL']
        destinations: ['Sentinel-ProofpointPOD_message_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), EventVendor = tostring(EventVendor), envelope_from_s = tostring(envelope_from_s), envelope_fromHashed_s = tostring(envelope_fromHashed_s), envelope_rcpts_s = tostring(envelope_rcpts_s), envelope_rcptsHashed_s = tostring(envelope_rcptsHashed_s), guid_s = tostring(guid_s), filter_verified_rcpts_s = tostring(filter_verified_rcpts_s), filter_verified_rcptsHashed_s = tostring(filter_verified_rcptsHashed_s), filter_msgSizeBytes_d = toreal(filter_msgSizeBytes_d), filter_suborgs_sender_s = tostring(filter_suborgs_sender_s), filter_suborgs_rcpts_s = tostring(filter_suborgs_rcpts_s), filter_disposition_s = tostring(filter_disposition_s), filter_modules_zerohour_score_s = tostring(filter_modules_zerohour_score_s), filter_modules_pdr_v2_response_s = tostring(filter_modules_pdr_v2_response_s), filter_modules_dkimv_s = tostring(filter_modules_dkimv_s), filter_modules_urldefense_counts_total_d = toreal(filter_modules_urldefense_counts_total_d), filter_modules_urldefense_counts_rewritten_d = toreal(filter_modules_urldefense_counts_rewritten_d), filter_modules_urldefense_counts_unique_d = toreal(filter_modules_urldefense_counts_unique_d), filter_modules_urldefense_version_engine_s = tostring(filter_modules_urldefense_version_engine_s), filter_modules_spam_langs_s = tostring(filter_modules_spam_langs_s), filter_modules_spam_scores_classifiers_s = tostring(filter_modules_spam_scores_classifiers_s), filter_modules_spam_scores_engine_d = toreal(filter_modules_spam_scores_engine_d), filter_modules_spam_scores_overall_d = toreal(filter_modules_spam_scores_overall_d), filter_modules_spam_version_definitions_s = tostring(filter_modules_spam_version_definitions_s), event_type_s = tostring(event_type_s), msg_normalizedHeader_return_pathHashed_s = tostring(msg_normalizedHeader_return_pathHashed_s), msg_normalizedHeader_x_mailer_s = tostring(msg_normalizedHeader_x_mailer_s), msg_normalizedHeader_return_path_s = tostring(msg_normalizedHeader_return_path_s), filter_modules_urldefense_counts_noRewriteIsSchemeless_d = toreal(filter_modules_urldefense_counts_noRewriteIsSchemeless_d), filter_modules_urldefense_counts_noRewriteIsUnsupportedScheme_d = toreal(filter_modules_urldefense_counts_noRewriteIsUnsupportedScheme_d), filter_throttleIp_s = tostring(filter_throttleIp_s), filter_modules_av_virusNames_s = tostring(filter_modules_av_virusNames_s), msg_header_cc_s = tostring(msg_header_cc_s), msg_header_ccHashed_s = tostring(msg_header_ccHashed_s), msg_parsedAddresses_cc_s = tostring(msg_parsedAddresses_cc_s), msg_parsedAddresses_ccHashed_s = tostring(msg_parsedAddresses_ccHashed_s), msg_normalizedHeader_ccHashed_s = tostring(msg_normalizedHeader_ccHashed_s), msg_normalizedHeader_cc_s = tostring(msg_normalizedHeader_cc_s), filter_origGuid_s = tostring(filter_origGuid_s), filter_modules_spam_version_engine_s = tostring(filter_modules_spam_version_engine_s), filter_modules_pdr_v2_rscore_d = toreal(filter_modules_pdr_v2_rscore_d), msg_header_reply_to_s = tostring(msg_header_reply_to_s), msg_header_reply_toHashed_s = tostring(msg_header_reply_toHashed_s), msg_normalizedHeader_reply_toHashed_s = tostring(msg_normalizedHeader_reply_toHashed_s), msg_normalizedHeader_reply_to_s = tostring(msg_normalizedHeader_reply_to_s), msg_header_x_originating_ip_s = tostring(msg_header_x_originating_ip_s), msg_normalizedHeader_x_originating_ip_s = tostring(msg_normalizedHeader_x_originating_ip_s), filter_modules_dmarc_alignment_s = tostring(filter_modules_dmarc_alignment_s), filter_modules_spam_charsets_s = tostring(filter_modules_spam_charsets_s), msg_header_return_path_s = tostring(msg_header_return_path_s), msg_header_return_pathHashed_s = tostring(msg_header_return_pathHashed_s), msg_header_x_mailer_s = tostring(msg_header_x_mailer_s), filter_modules_urldefense_counts_noRewriteIsEmail_d = toreal(filter_modules_urldefense_counts_noRewriteIsEmail_d), filter_modules_urldefense_counts_noRewriteIsMaxLengthExceeded_d = toreal(filter_modules_urldefense_counts_noRewriteIsMaxLengthExceeded_d), filter_modules_spam_safeBlockedListMatches_s = tostring(filter_modules_spam_safeBlockedListMatches_s), filter_modules_spf_result_s = tostring(filter_modules_spf_result_s), msg_normalizedHeader_subject_s = tostring(msg_normalizedHeader_subject_s), msg_lang_s = tostring(msg_lang_s), msg_sizeBytes_d = toreal(msg_sizeBytes_d), connection_resolveStatus_s = tostring(connection_resolveStatus_s), connection_protocol_s = tostring(connection_protocol_s), connection_helo_s = tostring(connection_helo_s), connection_country_s = tostring(connection_country_s), connection_host_s = tostring(connection_host_s), connection_sid_s = tostring(connection_sid_s), connection_ip_s = tostring(connection_ip_s), connection_tls_inbound_version_s = tostring(connection_tls_inbound_version_s), connection_tls_inbound_cipherBits_d = toreal(connection_tls_inbound_cipherBits_d), connection_tls_inbound_cipher_s = tostring(connection_tls_inbound_cipher_s), ts_t = todatetime(ts_t), metadata_origin_data_cid_s = tostring(metadata_origin_data_cid_s), metadata_origin_data_version_s = tostring(metadata_origin_data_version_s), metadata_origin_data_agent_s = tostring(metadata_origin_data_agent_s), msgParts_s = tostring(msgParts_s), pps_cid_s = tostring(pps_cid_s), pps_version_s = tostring(pps_version_s), pps_agent_s = tostring(pps_agent_s), filter_modules_urldefense_counts_noRewriteIsLargeMsgPartSize_d = toreal(filter_modules_urldefense_counts_noRewriteIsLargeMsgPartSize_d), EventProduct = tostring(EventProduct), msg_normalizedHeader_message_id_s = tostring(msg_normalizedHeader_message_id_s), msg_normalizedHeader_to_s = tostring(msg_normalizedHeader_to_s), msg_normalizedHeader_toHashed_s = tostring(msg_normalizedHeader_toHashed_s), msg_normalizedHeader_from_s = tostring(msg_normalizedHeader_from_s), filter_modules_spf_domain_s = tostring(filter_modules_spf_domain_s), filter_modules_dmarc_authResults_s = tostring(filter_modules_dmarc_authResults_s), filter_modules_dmarc_filterdResult_s = tostring(filter_modules_dmarc_filterdResult_s), filter_modules_dmarc_records_s = tostring(filter_modules_dmarc_records_s), filter_modules_dmarc_srvid_s = tostring(filter_modules_dmarc_srvid_s), filter_quarantine_folder_s = tostring(filter_quarantine_folder_s), filter_quarantine_rule_s = tostring(filter_quarantine_rule_s), filter_routeDirection_s = tostring(filter_routeDirection_s), filter_startTime_t = todatetime(filter_startTime_t), filter_qid_s = tostring(filter_qid_s), filter_routes_s = tostring(filter_routes_s), filter_modules_spam_triggeredClassifier_s = tostring(filter_modules_spam_triggeredClassifier_s), filter_actions_s = tostring(filter_actions_s), msg_parsedAddresses_to_s = tostring(msg_parsedAddresses_to_s), msg_parsedAddresses_toHashed_s = tostring(msg_parsedAddresses_toHashed_s), msg_parsedAddresses_from_s = tostring(msg_parsedAddresses_from_s), msg_parsedAddresses_fromHashed_s = tostring(msg_parsedAddresses_fromHashed_s), msg_header_toHashed_s = tostring(msg_header_toHashed_s), msg_header_to_s = tostring(msg_header_to_s), msg_header_subject_s = tostring(msg_header_subject_s), msg_header_message_id_s = tostring(msg_header_message_id_s), msg_header_fromHashed_s = tostring(msg_header_fromHashed_s), msg_header_from_s = tostring(msg_header_from_s), msg_normalizedHeader_fromHashed_s = tostring(msg_normalizedHeader_fromHashed_s), filter_durationSecs_d = toreal(filter_durationSecs_d), filter_modules_urldefense_counts_noRewriteIsExcludedDomain_d = toreal(filter_modules_urldefense_counts_noRewriteIsExcludedDomain_d)'
        outputStream: 'Custom-ProofpointPOD_message_CL'
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
