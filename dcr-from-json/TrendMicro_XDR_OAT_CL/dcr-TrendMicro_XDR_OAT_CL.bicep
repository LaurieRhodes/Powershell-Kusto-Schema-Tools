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
// Data Collection Rule for TrendMicro_XDR_OAT_CL
// ============================================================================
// Generated: 2025-09-18 08:37:39
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns filtered out
// Original columns: 592, DCR columns: 588 (Type column always filtered)
// Output stream: Custom-TrendMicro_XDR_OAT_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-TrendMicro_XDR_OAT_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-TrendMicro_XDR_OAT_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: 'authId_s'
            type: 'string'
          }
          {
            name: 'detail_processHashId_d_s'
            type: 'string'
          }
          {
            name: 'detail_processLaunchTime_d_d'
            type: 'string'
          }
          {
            name: 'detail_processName_s_s'
            type: 'string'
          }
          {
            name: 'detail_processPid_d_d'
            type: 'string'
          }
          {
            name: 'detail_processSigner_s_s'
            type: 'string'
          }
          {
            name: 'detail_processSignerValid_s_s'
            type: 'string'
          }
          {
            name: 'detail_processFileSize_d_d'
            type: 'string'
          }
          {
            name: 'detail_processTrueType_d_d'
            type: 'string'
          }
          {
            name: 'detail_processUserDomain_s_s'
            type: 'string'
          }
          {
            name: 'detail_productCode_s_s'
            type: 'string'
          }
          {
            name: 'detail_pver_s_s'
            type: 'string'
          }
          {
            name: 'detail_sessionId_d_d'
            type: 'string'
          }
          {
            name: 'detail_timezone_s_s'
            type: 'string'
          }
          {
            name: 'detail_userDomain_s_s'
            type: 'string'
          }
          {
            name: 'detail_processUser_s_s'
            type: 'string'
          }
          {
            name: 'detail_uuid_g_g'
            type: 'string'
          }
          {
            name: 'detail_processFileModifiedTime_d_d'
            type: 'string'
          }
          {
            name: 'detail_processFileHashSha1_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentName_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentPid_d_s'
            type: 'string'
          }
          {
            name: 'detail_parentSessionId_d_s'
            type: 'string'
          }
          {
            name: 'detail_parentSigner_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentSignerValid_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentTrueType_d_s'
            type: 'string'
          }
          {
            name: 'detail_processFileHashSha256_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentUser_s_s'
            type: 'string'
          }
          {
            name: 'detail_plang_d_d'
            type: 'string'
          }
          {
            name: 'detail_pname_s_d'
            type: 'string'
          }
          {
            name: 'detail_pplat_d_d'
            type: 'string'
          }
          {
            name: 'detail_processFileCreation_d_d'
            type: 'string'
          }
          {
            name: 'detail_processFileHashId_d_s'
            type: 'string'
          }
          {
            name: 'detail_processFileHashMd5_g_g'
            type: 'string'
          }
          {
            name: 'detail_parentUserDomain_s_s'
            type: 'string'
          }
          {
            name: 'Type_s'
            type: 'string'
          }
          {
            name: 'detail_app_s'
            type: 'string'
          }
          {
            name: 'detail_blocking_s'
            type: 'string'
          }
          {
            name: 'detail_rawDataStr_s'
            type: 'string'
          }
          {
            name: 'detail_rt_d'
            type: 'string'
          }
          {
            name: 'detail_winEventId_d'
            type: 'string'
          }
          {
            name: 'detail_confidence_d'
            type: 'string'
          }
          {
            name: 'detail_detectionName_s'
            type: 'string'
          }
          {
            name: 'detail_detectionType_s'
            type: 'string'
          }
          {
            name: 'detail_rawDataSize_d'
            type: 'string'
          }
          {
            name: 'detail_fileCreation_t'
            type: 'string'
          }
          {
            name: 'detail_threatType_s'
            type: 'string'
          }
          {
            name: 'detail_act_s'
            type: 'string'
          }
          {
            name: 'detail_aggregatedCount_d'
            type: 'string'
          }
          {
            name: 'detail_behaviorCat_s'
            type: 'string'
          }
          {
            name: 'detail_bmGroup_s'
            type: 'string'
          }
          {
            name: 'detail_engineOperation_s'
            type: 'string'
          }
          {
            name: 'detail_fileSize_d'
            type: 'string'
          }
          {
            name: 'detail_providerName_s'
            type: 'string'
          }
          {
            name: 'detail_providerGUID_g'
            type: 'string'
          }
          {
            name: 'detail_eventDataProviderPath_s'
            type: 'string'
          }
          {
            name: 'detail_cccaDetectionSource_s'
            type: 'string'
          }
          {
            name: 'detail_cccaRiskLevel_d'
            type: 'string'
          }
          {
            name: 'detail_direction_s'
            type: 'string'
          }
          {
            name: 'detail_interestedHost_s'
            type: 'string'
          }
          {
            name: 'detail_policyName_s'
            type: 'string'
          }
          {
            name: 'detail_rating_s'
            type: 'string'
          }
          {
            name: 'detail_request_s'
            type: 'string'
          }
          {
            name: 'detail_score_d'
            type: 'string'
          }
          {
            name: 'detail_urlCat_s'
            type: 'string'
          }
          {
            name: 'detail_patType_s'
            type: 'string'
          }
          {
            name: 'detail_suid_s'
            type: 'string'
          }
          {
            name: 'detail_compressedFileName_s'
            type: 'string'
          }
          {
            name: 'detail_malFamily_s'
            type: 'string'
          }
          {
            name: 'detail_correlationData_s'
            type: 'string'
          }
          {
            name: 'detail_eventDataProviderName_s'
            type: 'string'
          }
          {
            name: 'detail_parentLaunchTime_d_s'
            type: 'string'
          }
          {
            name: 'detail_parentIntegrityLevel_d_s'
            type: 'string'
          }
          {
            name: 'detail_parentHashId_d_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileSize_d_s'
            type: 'string'
          }
          {
            name: 'entityName_s_s'
            type: 'string'
          }
          {
            name: 'detail_endpointHostName_s_s'
            type: 'string'
          }
          {
            name: 'detail_endpointIp_s_s'
            type: 'string'
          }
          {
            name: 'detail_logonUser_s_s'
            type: 'string'
          }
          {
            name: 'detail_processFilePath_s_s'
            type: 'string'
          }
          {
            name: 'detail_processCmd_s_s'
            type: 'string'
          }
          {
            name: 'entityType_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventSubId_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectCmd_s_s'
            type: 'string'
          }
          {
            name: 'detail_tags_s_s'
            type: 'string'
          }
          {
            name: 'detail_endpointGuid_g_g'
            type: 'string'
          }
          {
            name: 'detail_authId_d_d'
            type: 'string'
          }
          {
            name: 'detail_endpointMacAddress_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventHashId_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectFilePath_s_s'
            type: 'string'
          }
          {
            name: 'filters_s_s'
            type: 'string'
          }
          {
            name: 'endpoint_ips_s_s'
            type: 'string'
          }
          {
            name: 'endpoint_guid_g_g'
            type: 'string'
          }
          {
            name: 'detail_deviceType_s_s'
            type: 'string'
          }
          {
            name: 'detail_nativeDeviceCharacteristics_d_s'
            type: 'string'
          }
          {
            name: 'detail_nativeDeviceType_d_s'
            type: 'string'
          }
          {
            name: 'detail_nativeStorageDeviceBusType_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectSubTrueType_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectFirstSeen_d_d'
            type: 'string'
          }
          {
            name: 'detail_objectLastSeen_d_d'
            type: 'string'
          }
          {
            name: 'detail_objectRegType_d_d'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryData_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryKeyHandle_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryRoot_d_d'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryValue_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventSourceType_s_s'
            type: 'string'
          }
          {
            name: 'xdrCustomerId_g_g'
            type: 'string'
          }
          {
            name: 'endpoint_name_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventId_s_s'
            type: 'string'
          }
          {
            name: 'detail_instanceId_g'
            type: 'string'
          }
          {
            name: 'detail_eventTime_d_d'
            type: 'string'
          }
          {
            name: 'detail_integrityLevel_d_d'
            type: 'string'
          }
          {
            name: 'detail_objectUserDomain_s_s'
            type: 'string'
          }
          {
            name: 'detail_osDescription_s_s'
            type: 'string'
          }
          {
            name: 'detail_osName_s_s'
            type: 'string'
          }
          {
            name: 'detail_osType_s_d'
            type: 'string'
          }
          {
            name: 'detail_osVer_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentAuthId_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectUser_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentCmd_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashId_d_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashMd5_g_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashSha1_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashSha256_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileModifiedTime_d_s'
            type: 'string'
          }
          {
            name: 'detail_parentFilePath_s_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileCreation_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectTrueType_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectSignerValid_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectSigner_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectAuthId_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileCreation_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashId_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashMd5_g_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashSha1_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashSha256_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileModifiedTime_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileSize_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectHashId_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectIntegrityLevel_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectLaunchTime_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectName_s_s'
            type: 'string'
          }
          {
            name: 'detail_objectPid_d_s'
            type: 'string'
          }
          {
            name: 'detail_objectRunAsLocalAccount_b_s'
            type: 'string'
          }
          {
            name: 'detail_objectSessionId_d_s'
            type: 'string'
          }
          {
            name: 'detail_filterRiskLevel_s_s'
            type: 'string'
          }
          {
            name: 'detail_severity_d_s'
            type: 'string'
          }
          {
            name: 'detail_policyId_s'
            type: 'string'
          }
          {
            name: 'detail_ruleId_d'
            type: 'string'
          }
          {
            name: 'detail_objectTrueType_d'
            type: 'string'
          }
          {
            name: 'detail_objectUser_s'
            type: 'string'
          }
          {
            name: 'detail_objectUserDomain_s'
            type: 'string'
          }
          {
            name: 'detail_osDescription_s'
            type: 'string'
          }
          {
            name: 'detail_osName_s'
            type: 'string'
          }
          {
            name: 'detail_osType_s'
            type: 'string'
          }
          {
            name: 'detail_objectSignerValid_s'
            type: 'string'
          }
          {
            name: 'detail_osVer_s'
            type: 'string'
          }
          {
            name: 'detail_parentCmd_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileCreation_d'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashId_d'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashMd5_g'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashSha1_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashSha256_s'
            type: 'string'
          }
          {
            name: 'detail_parentAuthId_d'
            type: 'string'
          }
          {
            name: 'detail_parentFileModifiedTime_d'
            type: 'string'
          }
          {
            name: 'detail_objectSigner_s'
            type: 'string'
          }
          {
            name: 'detail_objectRunAsLocalAccount_b'
            type: 'string'
          }
          {
            name: 'detail_lastSeen_t'
            type: 'string'
          }
          {
            name: 'detail_objectAuthId_d'
            type: 'string'
          }
          {
            name: 'detail_objectFileCreation_d'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashId_d'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashMd5_g'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashSha1_s'
            type: 'string'
          }
          {
            name: 'detail_objectSessionId_d'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashSha256_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileSize_d'
            type: 'string'
          }
          {
            name: 'detail_objectHashId_d'
            type: 'string'
          }
          {
            name: 'detail_objectIntegrityLevel_d'
            type: 'string'
          }
          {
            name: 'detail_objectLaunchTime_d'
            type: 'string'
          }
          {
            name: 'detail_objectName_s'
            type: 'string'
          }
          {
            name: 'detail_objectPid_d'
            type: 'string'
          }
          {
            name: 'detail_objectFileModifiedTime_d'
            type: 'string'
          }
          {
            name: 'detail_parentFilePath_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileSize_d'
            type: 'string'
          }
          {
            name: 'detail_parentHashId_d'
            type: 'string'
          }
          {
            name: 'detail_processFileSize_d'
            type: 'string'
          }
          {
            name: 'detail_processHashId_d'
            type: 'string'
          }
          {
            name: 'detail_processLaunchTime_d'
            type: 'string'
          }
          {
            name: 'detail_processName_s'
            type: 'string'
          }
          {
            name: 'detail_processPid_d'
            type: 'string'
          }
          {
            name: 'detail_processSigner_s'
            type: 'string'
          }
          {
            name: 'detail_processFileModifiedTime_d'
            type: 'string'
          }
          {
            name: 'detail_processSignerValid_s'
            type: 'string'
          }
          {
            name: 'detail_processUser_s'
            type: 'string'
          }
          {
            name: 'detail_processUserDomain_s'
            type: 'string'
          }
          {
            name: 'detail_productCode_s'
            type: 'string'
          }
          {
            name: 'detail_pver_s'
            type: 'string'
          }
          {
            name: 'detail_sessionId_d'
            type: 'string'
          }
          {
            name: 'detail_timezone_s'
            type: 'string'
          }
          {
            name: 'detail_processTrueType_d'
            type: 'string'
          }
          {
            name: 'detail_processFileHashSha256_s'
            type: 'string'
          }
          {
            name: 'detail_processFileHashSha1_s'
            type: 'string'
          }
          {
            name: 'detail_processFileHashMd5_g'
            type: 'string'
          }
          {
            name: 'detail_parentIntegrityLevel_d'
            type: 'string'
          }
          {
            name: 'detail_parentLaunchTime_d'
            type: 'string'
          }
          {
            name: 'detail_parentName_s'
            type: 'string'
          }
          {
            name: 'detail_parentPid_d'
            type: 'string'
          }
          {
            name: 'detail_parentSessionId_d'
            type: 'string'
          }
          {
            name: 'detail_parentSigner_s'
            type: 'string'
          }
          {
            name: 'detail_parentSignerValid_s'
            type: 'string'
          }
          {
            name: 'detail_parentTrueType_d'
            type: 'string'
          }
          {
            name: 'detail_parentUser_s'
            type: 'string'
          }
          {
            name: 'detail_parentUserDomain_s'
            type: 'string'
          }
          {
            name: 'detail_plang_d'
            type: 'string'
          }
          {
            name: 'detail_pname_s'
            type: 'string'
          }
          {
            name: 'detail_pplat_d'
            type: 'string'
          }
          {
            name: 'detail_processFileCreation_d'
            type: 'string'
          }
          {
            name: 'detail_processFileHashId_d'
            type: 'string'
          }
          {
            name: 'detail_integrityLevel_d'
            type: 'string'
          }
          {
            name: 'detail_firstSeen_t'
            type: 'string'
          }
          {
            name: 'detail_filterRiskLevel_s'
            type: 'string'
          }
          {
            name: 'detail_eventTimeDT_t'
            type: 'string'
          }
          {
            name: 'detail_mDevice_s'
            type: 'string'
          }
          {
            name: 'detail_mDeviceGUID_g'
            type: 'string'
          }
          {
            name: 'detail_malDst_s'
            type: 'string'
          }
          {
            name: 'detail_malName_s'
            type: 'string'
          }
          {
            name: 'detail_malSubType_s'
            type: 'string'
          }
          {
            name: 'detail_malType_s'
            type: 'string'
          }
          {
            name: 'detail_logKey_s'
            type: 'string'
          }
          {
            name: 'detail_mpname_s'
            type: 'string'
          }
          {
            name: 'detail_pComp_s'
            type: 'string'
          }
          {
            name: 'detail_patVer_s'
            type: 'string'
          }
          {
            name: 'detail_rt_t'
            type: 'string'
          }
          {
            name: 'detail_rtDate_s'
            type: 'string'
          }
          {
            name: 'detail_rtHour_d'
            type: 'string'
          }
          {
            name: 'detail_rtWeekDay_s'
            type: 'string'
          }
          {
            name: 'detail_mpver_s'
            type: 'string'
          }
          {
            name: 'detail_interestedIp_s'
            type: 'string'
          }
          {
            name: 'detail_fullPath_s'
            type: 'string'
          }
          {
            name: 'detail_firstActResult_s'
            type: 'string'
          }
          {
            name: 'detail_actResult_s'
            type: 'string'
          }
          {
            name: 'detail_channel_s'
            type: 'string'
          }
          {
            name: 'detail_deviceGUID_g'
            type: 'string'
          }
          {
            name: 'detail_domainName_s'
            type: 'string'
          }
          {
            name: 'detail_dvchost_s'
            type: 'string'
          }
          {
            name: 'detail_endpointGUID_g'
            type: 'string'
          }
          {
            name: 'detail_engType_s'
            type: 'string'
          }
          {
            name: 'detail_engVer_s'
            type: 'string'
          }
          {
            name: 'detail_eventId_d'
            type: 'string'
          }
          {
            name: 'detail_eventName_s'
            type: 'string'
          }
          {
            name: 'detail_eventSubName_s'
            type: 'string'
          }
          {
            name: 'detail_fileHash_s'
            type: 'string'
          }
          {
            name: 'detail_fileName_s'
            type: 'string'
          }
          {
            name: 'detail_filePath_s'
            type: 'string'
          }
          {
            name: 'detail_firstAct_s'
            type: 'string'
          }
          {
            name: 'detail_rt_utc_t'
            type: 'string'
          }
          {
            name: 'detail_riskLevel_s'
            type: 'string'
          }
          {
            name: 'detail_ruleName_s'
            type: 'string'
          }
          {
            name: 'detail_secondAct_s'
            type: 'string'
          }
          {
            name: 'detail_endpointIp_s'
            type: 'string'
          }
          {
            name: 'detail_logonUser_s'
            type: 'string'
          }
          {
            name: 'detail_processFilePath_s'
            type: 'string'
          }
          {
            name: 'detail_processCmd_s'
            type: 'string'
          }
          {
            name: 'detail_eventSubId_s'
            type: 'string'
          }
          {
            name: 'detail_objectFilePath_s'
            type: 'string'
          }
          {
            name: 'detail_endpointHostName_s'
            type: 'string'
          }
          {
            name: 'detail_objectCmd_s'
            type: 'string'
          }
          {
            name: 'detail_endpointGuid_g'
            type: 'string'
          }
          {
            name: 'detail_authId_d'
            type: 'string'
          }
          {
            name: 'detail_endpointMacAddress_s'
            type: 'string'
          }
          {
            name: 'detail_eventHashId_d'
            type: 'string'
          }
          {
            name: 'detail_eventId_s'
            type: 'string'
          }
          {
            name: 'detail_eventTime_d'
            type: 'string'
          }
          {
            name: 'detail_tags_s'
            type: 'string'
          }
          {
            name: 'endpoint_ips_s'
            type: 'string'
          }
          {
            name: 'detail_eventSourceType_s'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryValue_s'
            type: 'string'
          }
          {
            name: 'detail_secondActResult_s'
            type: 'string'
          }
          {
            name: 'detail_senderGUID_g'
            type: 'string'
          }
          {
            name: 'detail_senderIp_s'
            type: 'string'
          }
          {
            name: 'detail_severity_d'
            type: 'string'
          }
          {
            name: 'detail_deviceType_s'
            type: 'string'
          }
          {
            name: 'detail_nativeDeviceCharacteristics_d'
            type: 'string'
          }
          {
            name: 'detail_nativeDeviceType_d'
            type: 'string'
          }
          {
            name: 'detail_nativeStorageDeviceBusType_d'
            type: 'string'
          }
          {
            name: 'detail_objectSubTrueType_d'
            type: 'string'
          }
          {
            name: 'detail_objectFirstSeen_d'
            type: 'string'
          }
          {
            name: 'detail_objectLastSeen_d'
            type: 'string'
          }
          {
            name: 'detail_objectRegType_d'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryData_s'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryKeyHandle_s'
            type: 'string'
          }
          {
            name: 'detail_objectRegistryRoot_d'
            type: 'string'
          }
          {
            name: 'detail_scanType_s'
            type: 'string'
          }
          {
            name: 'detail_userDomain_s'
            type: 'string'
          }
          {
            name: 'detail_senderIp_s_s'
            type: 'string'
          }
          {
            name: 'detail_secondActResult_s_s'
            type: 'string'
          }
          {
            name: 'processFileModifiedTime_s'
            type: 'string'
          }
          {
            name: 'processFilePath_s'
            type: 'string'
          }
          {
            name: 'processFileSize_s'
            type: 'string'
          }
          {
            name: 'processHashId_s'
            type: 'string'
          }
          {
            name: 'processLaunchTime_s'
            type: 'string'
          }
          {
            name: 'processName_s'
            type: 'string'
          }
          {
            name: 'processFileCreation_s'
            type: 'string'
          }
          {
            name: 'processPid_d'
            type: 'string'
          }
          {
            name: 'processSignerValid_s'
            type: 'string'
          }
          {
            name: 'processTrueType_s'
            type: 'string'
          }
          {
            name: 'processUser_s'
            type: 'string'
          }
          {
            name: 'processUserDomain_s'
            type: 'string'
          }
          {
            name: 'productCode_s'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
          {
            name: 'processSigner_s'
            type: 'string'
          }
          {
            name: 'searchDL_s'
            type: 'string'
          }
          {
            name: 'processCmd_s'
            type: 'string'
          }
          {
            name: 'parentUserDomain_s'
            type: 'string'
          }
          {
            name: 'parentFileHashSha256_s'
            type: 'string'
          }
          {
            name: 'parentFileModifiedTime_s'
            type: 'string'
          }
          {
            name: 'parentFilePath_s'
            type: 'string'
          }
          {
            name: 'parentFileSize_s'
            type: 'string'
          }
          {
            name: 'parentHashId_s'
            type: 'string'
          }
          {
            name: 'parentIntegrityLevel_d'
            type: 'string'
          }
          {
            name: 'pname_s'
            type: 'string'
          }
          {
            name: 'parentLaunchTime_s'
            type: 'string'
          }
          {
            name: 'parentPid_d'
            type: 'string'
          }
          {
            name: 'parentSessionId_d'
            type: 'string'
          }
          {
            name: 'parentSigner_s'
            type: 'string'
          }
          {
            name: 'parentSignerValid_s'
            type: 'string'
          }
          {
            name: 'parentTrueType_d'
            type: 'string'
          }
          {
            name: 'parentUser_s'
            type: 'string'
          }
          {
            name: 'parentName_s'
            type: 'string'
          }
          {
            name: 'sessionId_d'
            type: 'string'
          }
          {
            name: 'source_s'
            type: 'string'
          }
          {
            name: 'SourceSystem'
            type: 'string'
          }
          {
            name: 'detail_providerGUID_s'
            type: 'string'
          }
          {
            name: 'detail_instanceId_s'
            type: 'string'
          }
          {
            name: 'detail_deviceGUID_s'
            type: 'string'
          }
          {
            name: 'detail_endpointGUID_s'
            type: 'string'
          }
          {
            name: 'detail_mDeviceGUID_s'
            type: 'string'
          }
          {
            name: 'detail_senderGUID_s'
            type: 'string'
          }
          {
            name: 'detail_score_s'
            type: 'string'
          }
          {
            name: 'detail_severity_s'
            type: 'string'
          }
          {
            name: 'detail_objectRunAsLocalAccount_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashMd5_s'
            type: 'string'
          }
          {
            name: 'detail_fileCreation_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_rt_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_rt_utc_UTC__s'
            type: 'string'
          }
          {
            name: 'detectionTime_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashMd5_s'
            type: 'string'
          }
          {
            name: 'detailessionId_s'
            type: 'string'
          }
          {
            name: 'detail_lastSeen_t_UTC_s'
            type: 'string'
          }
          {
            name: 'detail_firstSeen_t_UTC_s'
            type: 'string'
          }
          {
            name: 'tags_s'
            type: 'string'
          }
          {
            name: 'TenantId'
            type: 'string'
          }
          {
            name: 'timezone_s'
            type: 'string'
          }
          {
            name: 'userDomain_s'
            type: 'string'
          }
          {
            name: 'uuid_g'
            type: 'string'
          }
          {
            name: 'version_s'
            type: 'string'
          }
          {
            name: 'xdrCustomerId_g'
            type: 'string'
          }
          {
            name: 'detailuid_s_s'
            type: 'string'
          }
          {
            name: 'detail_fileCreation_t_UTC_s'
            type: 'string'
          }
          {
            name: 'detaileviceGUID_s'
            type: 'string'
          }
          {
            name: 'detail_rt_t_UTC_s'
            type: 'string'
          }
          {
            name: 'detail_rt_utc_t_UTC_s'
            type: 'string'
          }
          {
            name: 'detailenderGUID_s'
            type: 'string'
          }
          {
            name: 'detectionTime_t_UTC_s'
            type: 'string'
          }
          {
            name: 'detail_eventTimeDT_t_UTC_s'
            type: 'string'
          }
          {
            name: 'parentFileHashSha1_s'
            type: 'string'
          }
          {
            name: 'parentFileHashMd5_g'
            type: 'string'
          }
          {
            name: 'parentFileHashId_s'
            type: 'string'
          }
          {
            name: 'parentFileCreation_s'
            type: 'string'
          }
          {
            name: 'ingestionTime_t'
            type: 'string'
          }
          {
            name: 'integrityLevel_d'
            type: 'string'
          }
          {
            name: 'lastSeen_s'
            type: 'string'
          }
          {
            name: 'logonUser_s'
            type: 'string'
          }
          {
            name: 'ManagementGroupName'
            type: 'string'
          }
          {
            name: 'MG'
            type: 'string'
          }
          {
            name: 'firstSeen_s'
            type: 'string'
          }
          {
            name: 'nativeDeviceCharacteristics_d'
            type: 'string'
          }
          {
            name: 'nativeStorageDeviceBusType_d'
            type: 'string'
          }
          {
            name: 'objectAppName_s'
            type: 'string'
          }
          {
            name: 'objectAuthId_s'
            type: 'string'
          }
          {
            name: 'objectCmd_s'
            type: 'string'
          }
          {
            name: 'objectContentName_s'
            type: 'string'
          }
          {
            name: 'objectFileCreation_s'
            type: 'string'
          }
          {
            name: 'nativeDeviceType_d'
            type: 'string'
          }
          {
            name: 'filters_s'
            type: 'string'
          }
          {
            name: 'filterRiskLevel_s'
            type: 'string'
          }
          {
            name: 'eventTime_d'
            type: 'string'
          }
          {
            name: 'bitwiseFilterRiskLevel_d'
            type: 'string'
          }
          {
            name: 'Computer'
            type: 'string'
          }
          {
            name: 'detectionTime_t'
            type: 'string'
          }
          {
            name: 'deviceType_d'
            type: 'string'
          }
          {
            name: 'endpoint_guid_g'
            type: 'string'
          }
          {
            name: 'endpoint_name_s'
            type: 'string'
          }
          {
            name: 'endpointHostName_s'
            type: 'string'
          }
          {
            name: 'endpointIp_s'
            type: 'string'
          }
          {
            name: 'endpointMacAddress_s'
            type: 'string'
          }
          {
            name: 'entityName_s'
            type: 'string'
          }
          {
            name: 'entityType_s'
            type: 'string'
          }
          {
            name: 'eventHashId_s'
            type: 'string'
          }
          {
            name: 'eventId_s'
            type: 'string'
          }
          {
            name: 'eventSourceType_d'
            type: 'string'
          }
          {
            name: 'eventSubId_d'
            type: 'string'
          }
          {
            name: 'objectFileDaclString_s'
            type: 'string'
          }
          {
            name: 'detail_eventTimeDT_UTC__s'
            type: 'string'
          }
          {
            name: 'objectFileHashId_s'
            type: 'string'
          }
          {
            name: 'objectFileHashSha1_s'
            type: 'string'
          }
          {
            name: 'objectSessionId_s'
            type: 'string'
          }
          {
            name: 'objectSigner_s'
            type: 'string'
          }
          {
            name: 'objectSignerValid_s'
            type: 'string'
          }
          {
            name: 'objectSubTrueType_d'
            type: 'string'
          }
          {
            name: 'objectTrueType_d'
            type: 'string'
          }
          {
            name: 'objectUser_s'
            type: 'string'
          }
          {
            name: 'objectRunAsLocalAccount_b'
            type: 'string'
          }
          {
            name: 'objectUserDomain_s'
            type: 'string'
          }
          {
            name: 'osDescription_s'
            type: 'string'
          }
          {
            name: 'osType_s'
            type: 'string'
          }
          {
            name: 'osVer_s'
            type: 'string'
          }
          {
            name: 'packageTraceId_g'
            type: 'string'
          }
          {
            name: 'parentAuthId_s'
            type: 'string'
          }
          {
            name: 'parentCmd_s'
            type: 'string'
          }
          {
            name: 'os_s'
            type: 'string'
          }
          {
            name: 'objectRegType_d'
            type: 'string'
          }
          {
            name: 'objectRegistryValue_s'
            type: 'string'
          }
          {
            name: 'objectRegistryRoot_d'
            type: 'string'
          }
          {
            name: 'objectFileHashSha256_s'
            type: 'string'
          }
          {
            name: 'objectFileModifiedTime_s'
            type: 'string'
          }
          {
            name: 'objectFilePath_s'
            type: 'string'
          }
          {
            name: 'objectFileSize_s'
            type: 'string'
          }
          {
            name: 'objectFirstSeen_s'
            type: 'string'
          }
          {
            name: 'objectHashId_s'
            type: 'string'
          }
          {
            name: 'objectIntegrityLevel_d'
            type: 'string'
          }
          {
            name: 'objectLastSeen_s'
            type: 'string'
          }
          {
            name: 'objectLaunchTime_s'
            type: 'string'
          }
          {
            name: 'objectName_s'
            type: 'string'
          }
          {
            name: 'objectPid_d'
            type: 'string'
          }
          {
            name: 'objectRawDataSize_s'
            type: 'string'
          }
          {
            name: 'objectRawDataStr_s'
            type: 'string'
          }
          {
            name: 'objectRegistryData_s'
            type: 'string'
          }
          {
            name: 'objectRegistryKeyHandle_s'
            type: 'string'
          }
          {
            name: 'objectFileHashMd5_g'
            type: 'string'
          }
          {
            name: 'detail_senderGUID_g_s'
            type: 'string'
          }
          {
            name: 'detail_firstSeen_UTC__s'
            type: 'string'
          }
          {
            name: 'TimeGenerated_UTC_s'
            type: 'string'
          }
          {
            name: 'detail_rt_d_s'
            type: 'string'
          }
          {
            name: 'detail_winEventId_d_s'
            type: 'string'
          }
          {
            name: 'detail_confidence_d_s'
            type: 'string'
          }
          {
            name: 'detail_detectionName_s_s'
            type: 'string'
          }
          {
            name: 'detail_detectionType_s_s'
            type: 'string'
          }
          {
            name: 'detail_fileSize_d_s'
            type: 'string'
          }
          {
            name: 'detail_rawDataStr_s_s'
            type: 'string'
          }
          {
            name: 'detail_threatType_s_s'
            type: 'string'
          }
          {
            name: 'detail_aggregatedCount_d_s'
            type: 'string'
          }
          {
            name: 'detail_behaviorCat_s_s'
            type: 'string'
          }
          {
            name: 'detail_bmGroup_s_s'
            type: 'string'
          }
          {
            name: 'detail_engineOperation_s_s'
            type: 'string'
          }
          {
            name: 'detail_instanceId_g_s'
            type: 'string'
          }
          {
            name: 'detail_policyId_s_s'
            type: 'string'
          }
          {
            name: 'detail_act_s_s'
            type: 'string'
          }
          {
            name: 'detail_riskLevel_s_s'
            type: 'string'
          }
          {
            name: 'detail_rawDataSize_d_s'
            type: 'string'
          }
          {
            name: 'detail_providerGUID_g_s'
            type: 'string'
          }
          {
            name: 'detail_direction_s_s'
            type: 'string'
          }
          {
            name: 'detail_interestedHost_s_s'
            type: 'string'
          }
          {
            name: 'detail_policyName_s_s'
            type: 'string'
          }
          {
            name: 'detail_rating_s_s'
            type: 'string'
          }
          {
            name: 'detail_request_s_s'
            type: 'string'
          }
          {
            name: 'detail_score_d_s'
            type: 'string'
          }
          {
            name: 'detail_providerName_s_s'
            type: 'string'
          }
          {
            name: 'detail_urlCat_s_s'
            type: 'string'
          }
          {
            name: 'detail_suid_s_s'
            type: 'string'
          }
          {
            name: 'detail_compressedFileName_s_s'
            type: 'string'
          }
          {
            name: 'detail_malFamily_s_s'
            type: 'string'
          }
          {
            name: 'detail_correlationData_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventDataProviderName_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventDataProviderPath_s_s'
            type: 'string'
          }
          {
            name: 'detail_patType_s_s'
            type: 'string'
          }
          {
            name: 'detail_ruleId_d_s'
            type: 'string'
          }
          {
            name: 'detail_actResult_s_s'
            type: 'string'
          }
          {
            name: 'detail_channel_s_s'
            type: 'string'
          }
          {
            name: 'detail_malDst_s_s'
            type: 'string'
          }
          {
            name: 'detail_malName_s_s'
            type: 'string'
          }
          {
            name: 'detail_malSubType_s_s'
            type: 'string'
          }
          {
            name: 'detail_malType_s_s'
            type: 'string'
          }
          {
            name: 'detail_mpname_s_s'
            type: 'string'
          }
          {
            name: 'detail_mpver_s_s'
            type: 'string'
          }
          {
            name: 'detail_mDeviceGUID_g_s'
            type: 'string'
          }
          {
            name: 'detail_pComp_s_s'
            type: 'string'
          }
          {
            name: 'detail_rtDate_s_s'
            type: 'string'
          }
          {
            name: 'detail_rtHour_d_s'
            type: 'string'
          }
          {
            name: 'detail_rtWeekDay_s_s'
            type: 'string'
          }
          {
            name: 'detail_ruleName_s_s'
            type: 'string'
          }
          {
            name: 'detail_scanType_s_s'
            type: 'string'
          }
          {
            name: 'detail_secondAct_s_s'
            type: 'string'
          }
          {
            name: 'detail_patVer_s_s'
            type: 'string'
          }
          {
            name: 'detail_mDevice_s_s'
            type: 'string'
          }
          {
            name: 'detail_logKey_s_s'
            type: 'string'
          }
          {
            name: 'detail_interestedIp_s_s'
            type: 'string'
          }
          {
            name: 'detail_deviceGUID_g_s'
            type: 'string'
          }
          {
            name: 'detail_domainName_s_s'
            type: 'string'
          }
          {
            name: 'detail_dvchost_s_s'
            type: 'string'
          }
          {
            name: 'detail_endpointGUID_g_s'
            type: 'string'
          }
          {
            name: 'detail_engType_s_s'
            type: 'string'
          }
          {
            name: 'detail_engVer_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventId_d_s'
            type: 'string'
          }
          {
            name: 'detail_eventName_s_s'
            type: 'string'
          }
          {
            name: 'detail_eventSubName_s_s'
            type: 'string'
          }
          {
            name: 'detail_fileHash_s_s'
            type: 'string'
          }
          {
            name: 'detail_fileName_s_s'
            type: 'string'
          }
          {
            name: 'detail_filePath_s_s'
            type: 'string'
          }
          {
            name: 'detail_firstAct_s_s'
            type: 'string'
          }
          {
            name: 'detail_firstActResult_s_s'
            type: 'string'
          }
          {
            name: 'detail_fullPath_s_s'
            type: 'string'
          }
          {
            name: 'detail_cccaRiskLevel_d_s'
            type: 'string'
          }
          {
            name: 'detail_cccaDetectionSource_s_s'
            type: 'string'
          }
          {
            name: 'detail_blocking_s_s'
            type: 'string'
          }
          {
            name: 'detail_app_s_s'
            type: 'string'
          }
          {
            name: 'detail_rt_utc_t_UTC__s'
            type: 'string'
          }
          {
            name: 'detailcanType_s'
            type: 'string'
          }
          {
            name: 'detailecondAct_s'
            type: 'string'
          }
          {
            name: 'detailecondActResult_s'
            type: 'string'
          }
          {
            name: 'detailenderGUID_g_s'
            type: 'string'
          }
          {
            name: 'detailenderIp_s'
            type: 'string'
          }
          {
            name: 'detail_rtHour_s'
            type: 'string'
          }
          {
            name: 'detaileverity_s'
            type: 'string'
          }
          {
            name: 'detail_nativeDeviceCharacteristics_s'
            type: 'string'
          }
          {
            name: 'detail_nativeDeviceType_s'
            type: 'string'
          }
          {
            name: 'detail_nativeStorageDeviceBusType_s'
            type: 'string'
          }
          {
            name: 'detail_objectSubTrueType_s'
            type: 'string'
          }
          {
            name: 'xdrCustomerId_g_g_g'
            type: 'string'
          }
          {
            name: 'detectionTime_t_UTC__s'
            type: 'string'
          }
          {
            name: 'detaileviceType_s'
            type: 'string'
          }
          {
            name: 'detail_rt_t_UTC__s'
            type: 'string'
          }
          {
            name: 'detailvchost_s'
            type: 'string'
          }
          {
            name: 'detailomainName_s'
            type: 'string'
          }
          {
            name: 'detail_cccaRiskLevel_s'
            type: 'string'
          }
          {
            name: 'detailirection_s'
            type: 'string'
          }
          {
            name: 'detailcore_s'
            type: 'string'
          }
          {
            name: 'detailuid_s'
            type: 'string'
          }
          {
            name: 'detail_rawDataSize_s'
            type: 'string'
          }
          {
            name: 'detail_rt_s'
            type: 'string'
          }
          {
            name: 'detail_winEventId_s'
            type: 'string'
          }
          {
            name: 'detail_confidence_s'
            type: 'string'
          }
          {
            name: 'detailetectionName_s'
            type: 'string'
          }
          {
            name: 'detailetectionType_s'
            type: 'string'
          }
          {
            name: 'detail_fileCreation_t_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_fileSize_s'
            type: 'string'
          }
          {
            name: 'detail_aggregatedCount_s'
            type: 'string'
          }
          {
            name: 'detail_ruleId_s'
            type: 'string'
          }
          {
            name: 'detaileviceGUID_g_s'
            type: 'string'
          }
          {
            name: 'endpoint_guid_g_g_g'
            type: 'string'
          }
          {
            name: 'detail_lastSeen_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_endpointGuid_g_g_g'
            type: 'string'
          }
          {
            name: 'detail_eventTimeDT_t_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_parentHashId_s'
            type: 'string'
          }
          {
            name: 'detail_parentIntegrityLevel_s'
            type: 'string'
          }
          {
            name: 'detail_parentLaunchTime_s'
            type: 'string'
          }
          {
            name: 'detail_parentPid_s'
            type: 'string'
          }
          {
            name: 'detail_parentSessionId_s'
            type: 'string'
          }
          {
            name: 'detail_parentTrueType_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileSize_s'
            type: 'string'
          }
          {
            name: 'detail_pname_d'
            type: 'string'
          }
          {
            name: 'detail_processFileHashMd5_g_g_g'
            type: 'string'
          }
          {
            name: 'detail_processHashId_s'
            type: 'string'
          }
          {
            name: 'detailessionId_d'
            type: 'string'
          }
          {
            name: 'detail_uuid_g_g_g'
            type: 'string'
          }
          {
            name: 'MG_s'
            type: 'string'
          }
          {
            name: 'TimeGenerated_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_processFileHashId_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileModifiedTime_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileHashId_s'
            type: 'string'
          }
          {
            name: 'detail_parentFileCreation_s'
            type: 'string'
          }
          {
            name: 'detail_firstSeen_t_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_lastSeen_t_UTC__s'
            type: 'string'
          }
          {
            name: 'detail_objectAuthId_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileCreation_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileHashId_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileModifiedTime_s'
            type: 'string'
          }
          {
            name: 'detail_objectFileSize_s'
            type: 'string'
          }
          {
            name: 'detail_objectHashId_s'
            type: 'string'
          }
          {
            name: 'detail_objectIntegrityLevel_s'
            type: 'string'
          }
          {
            name: 'detail_objectLaunchTime_s'
            type: 'string'
          }
          {
            name: 'detail_objectPid_s'
            type: 'string'
          }
          {
            name: 'detail_objectSessionId_s'
            type: 'string'
          }
          {
            name: 'detail_objectTrueType_s'
            type: 'string'
          }
          {
            name: 'detail_osType_d'
            type: 'string'
          }
          {
            name: 'detail_parentAuthId_s'
            type: 'string'
          }
          {
            name: 'detail_eventHashId_s'
            type: 'string'
          }
          {
            name: 'detail_uuid_g'
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
          name: 'Sentinel-TrendMicro_XDR_OAT_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-TrendMicro_XDR_OAT_CL']
        destinations: ['Sentinel-TrendMicro_XDR_OAT_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), authId_s = tostring(authId_s), detail_processHashId_d_s = tostring(detail_processHashId_d_s), detail_processLaunchTime_d_d = toreal(detail_processLaunchTime_d_d), detail_processName_s_s = tostring(detail_processName_s_s), detail_processPid_d_d = toreal(detail_processPid_d_d), detail_processSigner_s_s = tostring(detail_processSigner_s_s), detail_processSignerValid_s_s = tostring(detail_processSignerValid_s_s), detail_processFileSize_d_d = toreal(detail_processFileSize_d_d), detail_processTrueType_d_d = toreal(detail_processTrueType_d_d), detail_processUserDomain_s_s = tostring(detail_processUserDomain_s_s), detail_productCode_s_s = tostring(detail_productCode_s_s), detail_pver_s_s = tostring(detail_pver_s_s), detail_sessionId_d_d = toreal(detail_sessionId_d_d), detail_timezone_s_s = tostring(detail_timezone_s_s), detail_userDomain_s_s = tostring(detail_userDomain_s_s), detail_processUser_s_s = tostring(detail_processUser_s_s), detail_uuid_g_g = tostring(detail_uuid_g_g), detail_processFileModifiedTime_d_d = toreal(detail_processFileModifiedTime_d_d), detail_processFileHashSha1_s_s = tostring(detail_processFileHashSha1_s_s), detail_parentName_s_s = tostring(detail_parentName_s_s), detail_parentPid_d_s = tostring(detail_parentPid_d_s), detail_parentSessionId_d_s = tostring(detail_parentSessionId_d_s), detail_parentSigner_s_s = tostring(detail_parentSigner_s_s), detail_parentSignerValid_s_s = tostring(detail_parentSignerValid_s_s), detail_parentTrueType_d_s = tostring(detail_parentTrueType_d_s), detail_processFileHashSha256_s_s = tostring(detail_processFileHashSha256_s_s), detail_parentUser_s_s = tostring(detail_parentUser_s_s), detail_plang_d_d = toreal(detail_plang_d_d), detail_pname_s_d = toreal(detail_pname_s_d), detail_pplat_d_d = toreal(detail_pplat_d_d), detail_processFileCreation_d_d = toreal(detail_processFileCreation_d_d), detail_processFileHashId_d_s = tostring(detail_processFileHashId_d_s), detail_processFileHashMd5_g_g = tostring(detail_processFileHashMd5_g_g), detail_parentUserDomain_s_s = tostring(detail_parentUserDomain_s_s), Type_s = tostring(Type_s), detail_app_s = tostring(detail_app_s), detail_blocking_s = tostring(detail_blocking_s), detail_rawDataStr_s = tostring(detail_rawDataStr_s), detail_rt_d = toreal(detail_rt_d), detail_winEventId_d = toreal(detail_winEventId_d), detail_confidence_d = toreal(detail_confidence_d), detail_detectionName_s = tostring(detail_detectionName_s), detail_detectionType_s = tostring(detail_detectionType_s), detail_rawDataSize_d = toreal(detail_rawDataSize_d), detail_fileCreation_t = todatetime(detail_fileCreation_t), detail_threatType_s = tostring(detail_threatType_s), detail_act_s = tostring(detail_act_s), detail_aggregatedCount_d = toreal(detail_aggregatedCount_d), detail_behaviorCat_s = tostring(detail_behaviorCat_s), detail_bmGroup_s = tostring(detail_bmGroup_s), detail_engineOperation_s = tostring(detail_engineOperation_s), detail_fileSize_d = toreal(detail_fileSize_d), detail_providerName_s = tostring(detail_providerName_s), detail_providerGUID_g = tostring(detail_providerGUID_g), detail_eventDataProviderPath_s = tostring(detail_eventDataProviderPath_s), detail_cccaDetectionSource_s = tostring(detail_cccaDetectionSource_s), detail_cccaRiskLevel_d = toreal(detail_cccaRiskLevel_d), detail_direction_s = tostring(detail_direction_s), detail_interestedHost_s = tostring(detail_interestedHost_s), detail_policyName_s = tostring(detail_policyName_s), detail_rating_s = tostring(detail_rating_s), detail_request_s = tostring(detail_request_s), detail_score_d = toreal(detail_score_d), detail_urlCat_s = tostring(detail_urlCat_s), detail_patType_s = tostring(detail_patType_s), detail_suid_s = tostring(detail_suid_s), detail_compressedFileName_s = tostring(detail_compressedFileName_s), detail_malFamily_s = tostring(detail_malFamily_s), detail_correlationData_s = tostring(detail_correlationData_s), detail_eventDataProviderName_s = tostring(detail_eventDataProviderName_s), detail_parentLaunchTime_d_s = tostring(detail_parentLaunchTime_d_s), detail_parentIntegrityLevel_d_s = tostring(detail_parentIntegrityLevel_d_s), detail_parentHashId_d_s = tostring(detail_parentHashId_d_s), detail_parentFileSize_d_s = tostring(detail_parentFileSize_d_s), entityName_s_s = tostring(entityName_s_s), detail_endpointHostName_s_s = tostring(detail_endpointHostName_s_s), detail_endpointIp_s_s = tostring(detail_endpointIp_s_s), detail_logonUser_s_s = tostring(detail_logonUser_s_s), detail_processFilePath_s_s = tostring(detail_processFilePath_s_s), detail_processCmd_s_s = tostring(detail_processCmd_s_s), entityType_s_s = tostring(entityType_s_s), detail_eventSubId_s_s = tostring(detail_eventSubId_s_s), detail_objectCmd_s_s = tostring(detail_objectCmd_s_s), detail_tags_s_s = tostring(detail_tags_s_s), detail_endpointGuid_g_g = tostring(detail_endpointGuid_g_g), detail_authId_d_d = toreal(detail_authId_d_d), detail_endpointMacAddress_s_s = tostring(detail_endpointMacAddress_s_s), detail_eventHashId_d_s = tostring(detail_eventHashId_d_s), detail_objectFilePath_s_s = tostring(detail_objectFilePath_s_s), filters_s_s = tostring(filters_s_s), endpoint_ips_s_s = tostring(endpoint_ips_s_s), endpoint_guid_g_g = tostring(endpoint_guid_g_g), detail_deviceType_s_s = tostring(detail_deviceType_s_s), detail_nativeDeviceCharacteristics_d_s = tostring(detail_nativeDeviceCharacteristics_d_s), detail_nativeDeviceType_d_s = tostring(detail_nativeDeviceType_d_s), detail_nativeStorageDeviceBusType_d_s = tostring(detail_nativeStorageDeviceBusType_d_s), detail_objectSubTrueType_d_s = tostring(detail_objectSubTrueType_d_s), detail_objectFirstSeen_d_d = toreal(detail_objectFirstSeen_d_d), detail_objectLastSeen_d_d = toreal(detail_objectLastSeen_d_d), detail_objectRegType_d_d = toreal(detail_objectRegType_d_d), detail_objectRegistryData_s_s = tostring(detail_objectRegistryData_s_s), detail_objectRegistryKeyHandle_s_s = tostring(detail_objectRegistryKeyHandle_s_s), detail_objectRegistryRoot_d_d = toreal(detail_objectRegistryRoot_d_d), detail_objectRegistryValue_s_s = tostring(detail_objectRegistryValue_s_s), detail_eventSourceType_s_s = tostring(detail_eventSourceType_s_s), xdrCustomerId_g_g = tostring(xdrCustomerId_g_g), endpoint_name_s_s = tostring(endpoint_name_s_s), detail_eventId_s_s = tostring(detail_eventId_s_s), detail_instanceId_g = tostring(detail_instanceId_g), detail_eventTime_d_d = toreal(detail_eventTime_d_d), detail_integrityLevel_d_d = toreal(detail_integrityLevel_d_d), detail_objectUserDomain_s_s = tostring(detail_objectUserDomain_s_s), detail_osDescription_s_s = tostring(detail_osDescription_s_s), detail_osName_s_s = tostring(detail_osName_s_s), detail_osType_s_d = toreal(detail_osType_s_d), detail_osVer_s_s = tostring(detail_osVer_s_s), detail_parentAuthId_d_s = tostring(detail_parentAuthId_d_s), detail_objectUser_s_s = tostring(detail_objectUser_s_s), detail_parentCmd_s_s = tostring(detail_parentCmd_s_s), detail_parentFileHashId_d_s = tostring(detail_parentFileHashId_d_s), detail_parentFileHashMd5_g_s = tostring(detail_parentFileHashMd5_g_s), detail_parentFileHashSha1_s_s = tostring(detail_parentFileHashSha1_s_s), detail_parentFileHashSha256_s_s = tostring(detail_parentFileHashSha256_s_s), detail_parentFileModifiedTime_d_s = tostring(detail_parentFileModifiedTime_d_s), detail_parentFilePath_s_s = tostring(detail_parentFilePath_s_s), detail_parentFileCreation_d_s = tostring(detail_parentFileCreation_d_s), detail_objectTrueType_d_s = tostring(detail_objectTrueType_d_s), detail_objectSignerValid_s_s = tostring(detail_objectSignerValid_s_s), detail_objectSigner_s_s = tostring(detail_objectSigner_s_s), detail_objectAuthId_d_s = tostring(detail_objectAuthId_d_s), detail_objectFileCreation_d_s = tostring(detail_objectFileCreation_d_s), detail_objectFileHashId_d_s = tostring(detail_objectFileHashId_d_s), detail_objectFileHashMd5_g_s = tostring(detail_objectFileHashMd5_g_s), detail_objectFileHashSha1_s_s = tostring(detail_objectFileHashSha1_s_s), detail_objectFileHashSha256_s_s = tostring(detail_objectFileHashSha256_s_s), detail_objectFileModifiedTime_d_s = tostring(detail_objectFileModifiedTime_d_s), detail_objectFileSize_d_s = tostring(detail_objectFileSize_d_s), detail_objectHashId_d_s = tostring(detail_objectHashId_d_s), detail_objectIntegrityLevel_d_s = tostring(detail_objectIntegrityLevel_d_s), detail_objectLaunchTime_d_s = tostring(detail_objectLaunchTime_d_s), detail_objectName_s_s = tostring(detail_objectName_s_s), detail_objectPid_d_s = tostring(detail_objectPid_d_s), detail_objectRunAsLocalAccount_b_s = tostring(detail_objectRunAsLocalAccount_b_s), detail_objectSessionId_d_s = tostring(detail_objectSessionId_d_s), detail_filterRiskLevel_s_s = tostring(detail_filterRiskLevel_s_s), detail_severity_d_s = tostring(detail_severity_d_s), detail_policyId_s = tostring(detail_policyId_s), detail_ruleId_d = toreal(detail_ruleId_d), detail_objectTrueType_d = toreal(detail_objectTrueType_d), detail_objectUser_s = tostring(detail_objectUser_s), detail_objectUserDomain_s = tostring(detail_objectUserDomain_s), detail_osDescription_s = tostring(detail_osDescription_s), detail_osName_s = tostring(detail_osName_s), detail_osType_s = tostring(detail_osType_s), detail_objectSignerValid_s = tostring(detail_objectSignerValid_s), detail_osVer_s = tostring(detail_osVer_s), detail_parentCmd_s = tostring(detail_parentCmd_s), detail_parentFileCreation_d = toreal(detail_parentFileCreation_d), detail_parentFileHashId_d = toreal(detail_parentFileHashId_d), detail_parentFileHashMd5_g = tostring(detail_parentFileHashMd5_g), detail_parentFileHashSha1_s = tostring(detail_parentFileHashSha1_s), detail_parentFileHashSha256_s = tostring(detail_parentFileHashSha256_s), detail_parentAuthId_d = toreal(detail_parentAuthId_d), detail_parentFileModifiedTime_d = toreal(detail_parentFileModifiedTime_d), detail_objectSigner_s = tostring(detail_objectSigner_s), detail_objectRunAsLocalAccount_b = tobool(detail_objectRunAsLocalAccount_b), detail_lastSeen_t = todatetime(detail_lastSeen_t), detail_objectAuthId_d = toreal(detail_objectAuthId_d), detail_objectFileCreation_d = toreal(detail_objectFileCreation_d), detail_objectFileHashId_d = toreal(detail_objectFileHashId_d), detail_objectFileHashMd5_g = tostring(detail_objectFileHashMd5_g), detail_objectFileHashSha1_s = tostring(detail_objectFileHashSha1_s), detail_objectSessionId_d = toreal(detail_objectSessionId_d), detail_objectFileHashSha256_s = tostring(detail_objectFileHashSha256_s), detail_objectFileSize_d = toreal(detail_objectFileSize_d), detail_objectHashId_d = toreal(detail_objectHashId_d), detail_objectIntegrityLevel_d = toreal(detail_objectIntegrityLevel_d), detail_objectLaunchTime_d = toreal(detail_objectLaunchTime_d), detail_objectName_s = tostring(detail_objectName_s), detail_objectPid_d = toreal(detail_objectPid_d), detail_objectFileModifiedTime_d = toreal(detail_objectFileModifiedTime_d), detail_parentFilePath_s = tostring(detail_parentFilePath_s), detail_parentFileSize_d = toreal(detail_parentFileSize_d), detail_parentHashId_d = toreal(detail_parentHashId_d), detail_processFileSize_d = toreal(detail_processFileSize_d), detail_processHashId_d = toreal(detail_processHashId_d), detail_processLaunchTime_d = toreal(detail_processLaunchTime_d), detail_processName_s = tostring(detail_processName_s), detail_processPid_d = toreal(detail_processPid_d), detail_processSigner_s = tostring(detail_processSigner_s), detail_processFileModifiedTime_d = toreal(detail_processFileModifiedTime_d), detail_processSignerValid_s = tostring(detail_processSignerValid_s), detail_processUser_s = tostring(detail_processUser_s), detail_processUserDomain_s = tostring(detail_processUserDomain_s), detail_productCode_s = tostring(detail_productCode_s), detail_pver_s = tostring(detail_pver_s), detail_sessionId_d = toreal(detail_sessionId_d), detail_timezone_s = tostring(detail_timezone_s), detail_processTrueType_d = toreal(detail_processTrueType_d), detail_processFileHashSha256_s = tostring(detail_processFileHashSha256_s), detail_processFileHashSha1_s = tostring(detail_processFileHashSha1_s), detail_processFileHashMd5_g = tostring(detail_processFileHashMd5_g), detail_parentIntegrityLevel_d = toreal(detail_parentIntegrityLevel_d), detail_parentLaunchTime_d = toreal(detail_parentLaunchTime_d), detail_parentName_s = tostring(detail_parentName_s), detail_parentPid_d = toreal(detail_parentPid_d), detail_parentSessionId_d = toreal(detail_parentSessionId_d), detail_parentSigner_s = tostring(detail_parentSigner_s), detail_parentSignerValid_s = tostring(detail_parentSignerValid_s), detail_parentTrueType_d = toreal(detail_parentTrueType_d), detail_parentUser_s = tostring(detail_parentUser_s), detail_parentUserDomain_s = tostring(detail_parentUserDomain_s), detail_plang_d = toreal(detail_plang_d), detail_pname_s = tostring(detail_pname_s), detail_pplat_d = toreal(detail_pplat_d), detail_processFileCreation_d = toreal(detail_processFileCreation_d), detail_processFileHashId_d = toreal(detail_processFileHashId_d), detail_integrityLevel_d = toreal(detail_integrityLevel_d), detail_firstSeen_t = todatetime(detail_firstSeen_t), detail_filterRiskLevel_s = tostring(detail_filterRiskLevel_s), detail_eventTimeDT_t = todatetime(detail_eventTimeDT_t), detail_mDevice_s = tostring(detail_mDevice_s), detail_mDeviceGUID_g = tostring(detail_mDeviceGUID_g), detail_malDst_s = tostring(detail_malDst_s), detail_malName_s = tostring(detail_malName_s), detail_malSubType_s = tostring(detail_malSubType_s), detail_malType_s = tostring(detail_malType_s), detail_logKey_s = tostring(detail_logKey_s), detail_mpname_s = tostring(detail_mpname_s), detail_pComp_s = tostring(detail_pComp_s), detail_patVer_s = tostring(detail_patVer_s), detail_rt_t = todatetime(detail_rt_t), detail_rtDate_s = tostring(detail_rtDate_s), detail_rtHour_d = toreal(detail_rtHour_d), detail_rtWeekDay_s = tostring(detail_rtWeekDay_s), detail_mpver_s = tostring(detail_mpver_s), detail_interestedIp_s = tostring(detail_interestedIp_s), detail_fullPath_s = tostring(detail_fullPath_s), detail_firstActResult_s = tostring(detail_firstActResult_s), detail_actResult_s = tostring(detail_actResult_s), detail_channel_s = tostring(detail_channel_s), detail_deviceGUID_g = tostring(detail_deviceGUID_g), detail_domainName_s = tostring(detail_domainName_s), detail_dvchost_s = tostring(detail_dvchost_s), detail_endpointGUID_g = tostring(detail_endpointGUID_g), detail_engType_s = tostring(detail_engType_s), detail_engVer_s = tostring(detail_engVer_s), detail_eventId_d = toreal(detail_eventId_d), detail_eventName_s = tostring(detail_eventName_s), detail_eventSubName_s = tostring(detail_eventSubName_s), detail_fileHash_s = tostring(detail_fileHash_s), detail_fileName_s = tostring(detail_fileName_s), detail_filePath_s = tostring(detail_filePath_s), detail_firstAct_s = tostring(detail_firstAct_s), detail_rt_utc_t = todatetime(detail_rt_utc_t), detail_riskLevel_s = tostring(detail_riskLevel_s), detail_ruleName_s = tostring(detail_ruleName_s), detail_secondAct_s = tostring(detail_secondAct_s), detail_endpointIp_s = tostring(detail_endpointIp_s), detail_logonUser_s = tostring(detail_logonUser_s), detail_processFilePath_s = tostring(detail_processFilePath_s), detail_processCmd_s = tostring(detail_processCmd_s), detail_eventSubId_s = tostring(detail_eventSubId_s), detail_objectFilePath_s = tostring(detail_objectFilePath_s), detail_endpointHostName_s = tostring(detail_endpointHostName_s), detail_objectCmd_s = tostring(detail_objectCmd_s), detail_endpointGuid_g = tostring(detail_endpointGuid_g), detail_authId_d = toreal(detail_authId_d), detail_endpointMacAddress_s = tostring(detail_endpointMacAddress_s), detail_eventHashId_d = toreal(detail_eventHashId_d), detail_eventId_s = tostring(detail_eventId_s), detail_eventTime_d = toreal(detail_eventTime_d), detail_tags_s = tostring(detail_tags_s), endpoint_ips_s = tostring(endpoint_ips_s), detail_eventSourceType_s = tostring(detail_eventSourceType_s), detail_objectRegistryValue_s = tostring(detail_objectRegistryValue_s), detail_secondActResult_s = tostring(detail_secondActResult_s), detail_senderGUID_g = tostring(detail_senderGUID_g), detail_senderIp_s = tostring(detail_senderIp_s), detail_severity_d = toreal(detail_severity_d), detail_deviceType_s = tostring(detail_deviceType_s), detail_nativeDeviceCharacteristics_d = toreal(detail_nativeDeviceCharacteristics_d), detail_nativeDeviceType_d = toreal(detail_nativeDeviceType_d), detail_nativeStorageDeviceBusType_d = toreal(detail_nativeStorageDeviceBusType_d), detail_objectSubTrueType_d = toreal(detail_objectSubTrueType_d), detail_objectFirstSeen_d = toreal(detail_objectFirstSeen_d), detail_objectLastSeen_d = toreal(detail_objectLastSeen_d), detail_objectRegType_d = toreal(detail_objectRegType_d), detail_objectRegistryData_s = tostring(detail_objectRegistryData_s), detail_objectRegistryKeyHandle_s = tostring(detail_objectRegistryKeyHandle_s), detail_objectRegistryRoot_d = toreal(detail_objectRegistryRoot_d), detail_scanType_s = tostring(detail_scanType_s), detail_userDomain_s = tostring(detail_userDomain_s), detail_senderIp_s_s = tostring(detail_senderIp_s_s), detail_secondActResult_s_s = tostring(detail_secondActResult_s_s), processFileModifiedTime_s = tostring(processFileModifiedTime_s), processFilePath_s = tostring(processFilePath_s), processFileSize_s = tostring(processFileSize_s), processHashId_s = tostring(processHashId_s), processLaunchTime_s = tostring(processLaunchTime_s), processName_s = tostring(processName_s), processFileCreation_s = tostring(processFileCreation_s), processPid_d = tostring(processPid_d), processSignerValid_s = tostring(processSignerValid_s), processTrueType_s = tostring(processTrueType_s), processUser_s = tostring(processUser_s), processUserDomain_s = tostring(processUserDomain_s), productCode_s = tostring(productCode_s), RawData = tostring(RawData), processSigner_s = toreal(processSigner_s), searchDL_s = tostring(searchDL_s), processCmd_s = tostring(processCmd_s), parentUserDomain_s = tostring(parentUserDomain_s), parentFileHashSha256_s = tostring(parentFileHashSha256_s), parentFileModifiedTime_s = tostring(parentFileModifiedTime_s), parentFilePath_s = tostring(parentFilePath_s), parentFileSize_s = tostring(parentFileSize_s), parentHashId_s = tostring(parentHashId_s), parentIntegrityLevel_d = toreal(parentIntegrityLevel_d), pname_s = tostring(pname_s), parentLaunchTime_s = tostring(parentLaunchTime_s), parentPid_d = toreal(parentPid_d), parentSessionId_d = toreal(parentSessionId_d), parentSigner_s = tostring(parentSigner_s), parentSignerValid_s = tostring(parentSignerValid_s), parentTrueType_d = toreal(parentTrueType_d), parentUser_s = tostring(parentUser_s), parentName_s = tostring(parentName_s), sessionId_d = tostring(sessionId_d), source_s = toreal(source_s), SourceSystem = tostring(SourceSystem), detail_providerGUID_s = tostring(detail_providerGUID_s), detail_instanceId_s = tostring(detail_instanceId_s), detail_deviceGUID_s = tostring(detail_deviceGUID_s), detail_endpointGUID_s = tostring(detail_endpointGUID_s), detail_mDeviceGUID_s = tostring(detail_mDeviceGUID_s), detail_senderGUID_s = tostring(detail_senderGUID_s), detail_score_s = tostring(detail_score_s), detail_severity_s = tostring(detail_severity_s), detail_objectRunAsLocalAccount_s = tostring(detail_objectRunAsLocalAccount_s), detail_parentFileHashMd5_s = tostring(detail_parentFileHashMd5_s), detail_fileCreation_UTC__s = tostring(detail_fileCreation_UTC__s), detail_rt_UTC__s = tostring(detail_rt_UTC__s), detail_rt_utc_UTC__s = tostring(detail_rt_utc_UTC__s), detectionTime_UTC__s = tostring(detectionTime_UTC__s), detail_objectFileHashMd5_s = tostring(detail_objectFileHashMd5_s), detailessionId_s = tostring(detailessionId_s), detail_lastSeen_t_UTC_s = tostring(detail_lastSeen_t_UTC_s), detail_firstSeen_t_UTC_s = tostring(detail_firstSeen_t_UTC_s), tags_s = tostring(tags_s), TenantId = toguid(TenantId), timezone_s = todatetime(timezone_s), userDomain_s = tostring(userDomain_s), uuid_g = tostring(uuid_g), version_s = tostring(version_s), xdrCustomerId_g = tostring(xdrCustomerId_g), detailuid_s_s = tostring(detailuid_s_s), detail_fileCreation_t_UTC_s = tostring(detail_fileCreation_t_UTC_s), detaileviceGUID_s = tostring(detaileviceGUID_s), detail_rt_t_UTC_s = tostring(detail_rt_t_UTC_s), detail_rt_utc_t_UTC_s = tostring(detail_rt_utc_t_UTC_s), detailenderGUID_s = tostring(detailenderGUID_s), detectionTime_t_UTC_s = tostring(detectionTime_t_UTC_s), detail_eventTimeDT_t_UTC_s = tostring(detail_eventTimeDT_t_UTC_s), parentFileHashSha1_s = tostring(parentFileHashSha1_s), parentFileHashMd5_g = tostring(parentFileHashMd5_g), parentFileHashId_s = tostring(parentFileHashId_s), parentFileCreation_s = tostring(parentFileCreation_s), ingestionTime_t = todatetime(ingestionTime_t), integrityLevel_d = toreal(integrityLevel_d), lastSeen_s = tostring(lastSeen_s), logonUser_s = tostring(logonUser_s), ManagementGroupName = tostring(ManagementGroupName), MG = tostring(MG), firstSeen_s = tostring(firstSeen_s), nativeDeviceCharacteristics_d = toreal(nativeDeviceCharacteristics_d), nativeStorageDeviceBusType_d = toreal(nativeStorageDeviceBusType_d), objectAppName_s = tostring(objectAppName_s), objectAuthId_s = tostring(objectAuthId_s), objectCmd_s = tostring(objectCmd_s), objectContentName_s = tostring(objectContentName_s), objectFileCreation_s = tostring(objectFileCreation_s), nativeDeviceType_d = toreal(nativeDeviceType_d), filters_s = tostring(filters_s), filterRiskLevel_s = tostring(filterRiskLevel_s), eventTime_d = toreal(eventTime_d), bitwiseFilterRiskLevel_d = toreal(bitwiseFilterRiskLevel_d), Computer = tostring(Computer), detectionTime_t = todatetime(detectionTime_t), deviceType_d = toreal(deviceType_d), endpoint_guid_g = tostring(endpoint_guid_g), endpoint_name_s = tostring(endpoint_name_s), endpointHostName_s = tostring(endpointHostName_s), endpointIp_s = tostring(endpointIp_s), endpointMacAddress_s = tostring(endpointMacAddress_s), entityName_s = tostring(entityName_s), entityType_s = tostring(entityType_s), eventHashId_s = tostring(eventHashId_s), eventId_s = tostring(eventId_s), eventSourceType_d = toreal(eventSourceType_d), eventSubId_d = toreal(eventSubId_d), objectFileDaclString_s = tostring(objectFileDaclString_s), detail_eventTimeDT_UTC__s = tostring(detail_eventTimeDT_UTC__s), objectFileHashId_s = tostring(objectFileHashId_s), objectFileHashSha1_s = tostring(objectFileHashSha1_s), objectSessionId_s = tostring(objectSessionId_s), objectSigner_s = tostring(objectSigner_s), objectSignerValid_s = tostring(objectSignerValid_s), objectSubTrueType_d = toreal(objectSubTrueType_d), objectTrueType_d = toreal(objectTrueType_d), objectUser_s = tostring(objectUser_s), objectRunAsLocalAccount_b = tobool(objectRunAsLocalAccount_b), objectUserDomain_s = tostring(objectUserDomain_s), osDescription_s = tostring(osDescription_s), osType_s = tostring(osType_s), osVer_s = tostring(osVer_s), packageTraceId_g = tostring(packageTraceId_g), parentAuthId_s = tostring(parentAuthId_s), parentCmd_s = tostring(parentCmd_s), os_s = tostring(os_s), objectRegType_d = toreal(objectRegType_d), objectRegistryValue_s = tostring(objectRegistryValue_s), objectRegistryRoot_d = toreal(objectRegistryRoot_d), objectFileHashSha256_s = tostring(objectFileHashSha256_s), objectFileModifiedTime_s = tostring(objectFileModifiedTime_s), objectFilePath_s = tostring(objectFilePath_s), objectFileSize_s = tostring(objectFileSize_s), objectFirstSeen_s = tostring(objectFirstSeen_s), objectHashId_s = tostring(objectHashId_s), objectIntegrityLevel_d = toreal(objectIntegrityLevel_d), objectLastSeen_s = tostring(objectLastSeen_s), objectLaunchTime_s = tostring(objectLaunchTime_s), objectName_s = tostring(objectName_s), objectPid_d = toreal(objectPid_d), objectRawDataSize_s = tostring(objectRawDataSize_s), objectRawDataStr_s = tostring(objectRawDataStr_s), objectRegistryData_s = tostring(objectRegistryData_s), objectRegistryKeyHandle_s = tostring(objectRegistryKeyHandle_s), objectFileHashMd5_g = tostring(objectFileHashMd5_g), detail_senderGUID_g_s = tostring(detail_senderGUID_g_s), detail_firstSeen_UTC__s = tostring(detail_firstSeen_UTC__s), TimeGenerated_UTC_s = tostring(TimeGenerated_UTC_s), detail_rt_d_s = tostring(detail_rt_d_s), detail_winEventId_d_s = tostring(detail_winEventId_d_s), detail_confidence_d_s = tostring(detail_confidence_d_s), detail_detectionName_s_s = tostring(detail_detectionName_s_s), detail_detectionType_s_s = tostring(detail_detectionType_s_s), detail_fileSize_d_s = tostring(detail_fileSize_d_s), detail_rawDataStr_s_s = tostring(detail_rawDataStr_s_s), detail_threatType_s_s = tostring(detail_threatType_s_s), detail_aggregatedCount_d_s = tostring(detail_aggregatedCount_d_s), detail_behaviorCat_s_s = tostring(detail_behaviorCat_s_s), detail_bmGroup_s_s = tostring(detail_bmGroup_s_s), detail_engineOperation_s_s = tostring(detail_engineOperation_s_s), detail_instanceId_g_s = tostring(detail_instanceId_g_s), detail_policyId_s_s = tostring(detail_policyId_s_s), detail_act_s_s = tostring(detail_act_s_s), detail_riskLevel_s_s = tostring(detail_riskLevel_s_s), detail_rawDataSize_d_s = tostring(detail_rawDataSize_d_s), detail_providerGUID_g_s = tostring(detail_providerGUID_g_s), detail_direction_s_s = tostring(detail_direction_s_s), detail_interestedHost_s_s = tostring(detail_interestedHost_s_s), detail_policyName_s_s = tostring(detail_policyName_s_s), detail_rating_s_s = tostring(detail_rating_s_s), detail_request_s_s = tostring(detail_request_s_s), detail_score_d_s = tostring(detail_score_d_s), detail_providerName_s_s = tostring(detail_providerName_s_s), detail_urlCat_s_s = tostring(detail_urlCat_s_s), detail_suid_s_s = tostring(detail_suid_s_s), detail_compressedFileName_s_s = tostring(detail_compressedFileName_s_s), detail_malFamily_s_s = tostring(detail_malFamily_s_s), detail_correlationData_s_s = tostring(detail_correlationData_s_s), detail_eventDataProviderName_s_s = tostring(detail_eventDataProviderName_s_s), detail_eventDataProviderPath_s_s = tostring(detail_eventDataProviderPath_s_s), detail_patType_s_s = tostring(detail_patType_s_s), detail_ruleId_d_s = tostring(detail_ruleId_d_s), detail_actResult_s_s = tostring(detail_actResult_s_s), detail_channel_s_s = tostring(detail_channel_s_s), detail_malDst_s_s = tostring(detail_malDst_s_s), detail_malName_s_s = tostring(detail_malName_s_s), detail_malSubType_s_s = tostring(detail_malSubType_s_s), detail_malType_s_s = tostring(detail_malType_s_s), detail_mpname_s_s = tostring(detail_mpname_s_s), detail_mpver_s_s = tostring(detail_mpver_s_s), detail_mDeviceGUID_g_s = tostring(detail_mDeviceGUID_g_s), detail_pComp_s_s = tostring(detail_pComp_s_s), detail_rtDate_s_s = tostring(detail_rtDate_s_s), detail_rtHour_d_s = tostring(detail_rtHour_d_s), detail_rtWeekDay_s_s = tostring(detail_rtWeekDay_s_s), detail_ruleName_s_s = tostring(detail_ruleName_s_s), detail_scanType_s_s = tostring(detail_scanType_s_s), detail_secondAct_s_s = tostring(detail_secondAct_s_s), detail_patVer_s_s = tostring(detail_patVer_s_s), detail_mDevice_s_s = tostring(detail_mDevice_s_s), detail_logKey_s_s = tostring(detail_logKey_s_s), detail_interestedIp_s_s = tostring(detail_interestedIp_s_s), detail_deviceGUID_g_s = tostring(detail_deviceGUID_g_s), detail_domainName_s_s = tostring(detail_domainName_s_s), detail_dvchost_s_s = tostring(detail_dvchost_s_s), detail_endpointGUID_g_s = tostring(detail_endpointGUID_g_s), detail_engType_s_s = tostring(detail_engType_s_s), detail_engVer_s_s = tostring(detail_engVer_s_s), detail_eventId_d_s = tostring(detail_eventId_d_s), detail_eventName_s_s = tostring(detail_eventName_s_s), detail_eventSubName_s_s = tostring(detail_eventSubName_s_s), detail_fileHash_s_s = tostring(detail_fileHash_s_s), detail_fileName_s_s = tostring(detail_fileName_s_s), detail_filePath_s_s = tostring(detail_filePath_s_s), detail_firstAct_s_s = tostring(detail_firstAct_s_s), detail_firstActResult_s_s = tostring(detail_firstActResult_s_s), detail_fullPath_s_s = tostring(detail_fullPath_s_s), detail_cccaRiskLevel_d_s = tostring(detail_cccaRiskLevel_d_s), detail_cccaDetectionSource_s_s = tostring(detail_cccaDetectionSource_s_s), detail_blocking_s_s = tostring(detail_blocking_s_s), detail_app_s_s = tostring(detail_app_s_s), detail_rt_utc_t_UTC__s = tostring(detail_rt_utc_t_UTC__s), detailcanType_s = tostring(detailcanType_s), detailecondAct_s = tostring(detailecondAct_s), detailecondActResult_s = tostring(detailecondActResult_s), detailenderGUID_g_s = tostring(detailenderGUID_g_s), detailenderIp_s = tostring(detailenderIp_s), detail_rtHour_s = tostring(detail_rtHour_s), detaileverity_s = tostring(detaileverity_s), detail_nativeDeviceCharacteristics_s = tostring(detail_nativeDeviceCharacteristics_s), detail_nativeDeviceType_s = tostring(detail_nativeDeviceType_s), detail_nativeStorageDeviceBusType_s = tostring(detail_nativeStorageDeviceBusType_s), detail_objectSubTrueType_s = tostring(detail_objectSubTrueType_s), xdrCustomerId_g_g_g = tostring(xdrCustomerId_g_g_g), detectionTime_t_UTC__s = tostring(detectionTime_t_UTC__s), detaileviceType_s = tostring(detaileviceType_s), detail_rt_t_UTC__s = tostring(detail_rt_t_UTC__s), detailvchost_s = tostring(detailvchost_s), detailomainName_s = tostring(detailomainName_s), detail_cccaRiskLevel_s = tostring(detail_cccaRiskLevel_s), detailirection_s = tostring(detailirection_s), detailcore_s = tostring(detailcore_s), detailuid_s = tostring(detailuid_s), detail_rawDataSize_s = tostring(detail_rawDataSize_s), detail_rt_s = tostring(detail_rt_s), detail_winEventId_s = tostring(detail_winEventId_s), detail_confidence_s = tostring(detail_confidence_s), detailetectionName_s = tostring(detailetectionName_s), detailetectionType_s = tostring(detailetectionType_s), detail_fileCreation_t_UTC__s = tostring(detail_fileCreation_t_UTC__s), detail_fileSize_s = tostring(detail_fileSize_s), detail_aggregatedCount_s = tostring(detail_aggregatedCount_s), detail_ruleId_s = tostring(detail_ruleId_s), detaileviceGUID_g_s = tostring(detaileviceGUID_g_s), endpoint_guid_g_g_g = tostring(endpoint_guid_g_g_g), detail_lastSeen_UTC__s = tostring(detail_lastSeen_UTC__s), detail_endpointGuid_g_g_g = tostring(detail_endpointGuid_g_g_g), detail_eventTimeDT_t_UTC__s = tostring(detail_eventTimeDT_t_UTC__s), detail_parentHashId_s = tostring(detail_parentHashId_s), detail_parentIntegrityLevel_s = tostring(detail_parentIntegrityLevel_s), detail_parentLaunchTime_s = tostring(detail_parentLaunchTime_s), detail_parentPid_s = tostring(detail_parentPid_s), detail_parentSessionId_s = tostring(detail_parentSessionId_s), detail_parentTrueType_s = tostring(detail_parentTrueType_s), detail_parentFileSize_s = tostring(detail_parentFileSize_s), detail_pname_d = toreal(detail_pname_d), detail_processFileHashMd5_g_g_g = tostring(detail_processFileHashMd5_g_g_g), detail_processHashId_s = tostring(detail_processHashId_s), detailessionId_d = toreal(detailessionId_d), detail_uuid_g_g_g = tostring(detail_uuid_g_g_g), MG_s = tostring(MG_s), TimeGenerated_UTC__s = tostring(TimeGenerated_UTC__s), detail_processFileHashId_s = tostring(detail_processFileHashId_s), detail_parentFileModifiedTime_s = tostring(detail_parentFileModifiedTime_s), detail_parentFileHashId_s = tostring(detail_parentFileHashId_s), detail_parentFileCreation_s = tostring(detail_parentFileCreation_s), detail_firstSeen_t_UTC__s = tostring(detail_firstSeen_t_UTC__s), detail_lastSeen_t_UTC__s = tostring(detail_lastSeen_t_UTC__s), detail_objectAuthId_s = tostring(detail_objectAuthId_s), detail_objectFileCreation_s = tostring(detail_objectFileCreation_s), detail_objectFileHashId_s = tostring(detail_objectFileHashId_s), detail_objectFileModifiedTime_s = tostring(detail_objectFileModifiedTime_s), detail_objectFileSize_s = tostring(detail_objectFileSize_s), detail_objectHashId_s = tostring(detail_objectHashId_s), detail_objectIntegrityLevel_s = tostring(detail_objectIntegrityLevel_s), detail_objectLaunchTime_s = tostring(detail_objectLaunchTime_s), detail_objectPid_s = tostring(detail_objectPid_s), detail_objectSessionId_s = tostring(detail_objectSessionId_s), detail_objectTrueType_s = tostring(detail_objectTrueType_s), detail_osType_d = toreal(detail_osType_d), detail_parentAuthId_s = tostring(detail_parentAuthId_s), detail_eventHashId_s = tostring(detail_eventHashId_s), detail_uuid_g = tostring(detail_uuid_g)'
        outputStream: 'Custom-TrendMicro_XDR_OAT_CL'
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
