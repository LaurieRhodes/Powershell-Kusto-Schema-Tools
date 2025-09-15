// Bicep template for Log Analytics custom table: TrendMicro_XDR_OAT_CL
// Generated on 2025-09-13 20:15:28 UTC
// Source: JSON schema export
// Original columns: 592, Deployed columns: 591 (only 'Type' filtered out)
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

resource trendmicroxdroatclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'TrendMicro_XDR_OAT_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'TrendMicro_XDR_OAT_CL'
      description: 'Custom table TrendMicro_XDR_OAT_CL - imported from JSON schema'
      displayName: 'TrendMicro_XDR_OAT_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: 'detail_processHashId_d_s'
          type: 'string'
        }
        {
          name: 'detail_processLaunchTime_d_d'
          type: 'real'
        }
        {
          name: 'detail_processName_s_s'
          type: 'string'
        }
        {
          name: 'detail_processPid_d_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_processTrueType_d_d'
          type: 'real'
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
          type: 'real'
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
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_pname_s_d'
          type: 'real'
        }
        {
          name: 'detail_pplat_d_d'
          type: 'real'
        }
        {
          name: 'detail_processFileCreation_d_d'
          type: 'real'
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
          name: '_ResourceId_s'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: 'detail_app_s'
          type: 'string'
        }
        {
          name: 'detail_rawDataSize_d'
          type: 'real'
        }
        {
          name: 'detail_rawDataStr_s'
          type: 'string'
        }
        {
          name: 'detail_rt_d'
          type: 'real'
        }
        {
          name: 'detail_winEventId_d'
          type: 'real'
        }
        {
          name: 'detail_confidence_d'
          type: 'real'
        }
        {
          name: 'detail_detectionName_s'
          type: 'string'
        }
        {
          name: 'detail_providerName_s'
          type: 'string'
        }
        {
          name: 'detail_detectionType_s'
          type: 'string'
        }
        {
          name: 'detail_fileSize_d'
          type: 'real'
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
          type: 'real'
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
          name: 'detail_fileCreation_t'
          type: 'dateTime'
        }
        {
          name: 'detail_providerGUID_g'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_eventDataProviderPath_s'
          type: 'string'
        }
        {
          name: 'detail_eventDataProviderName_s'
          type: 'string'
        }
        {
          name: 'detail_blocking_s'
          type: 'string'
        }
        {
          name: 'detail_cccaDetectionSource_s'
          type: 'string'
        }
        {
          name: 'detail_cccaRiskLevel_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_urlCat_s'
          type: 'string'
          dataTypeHint: 0
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
          dataTypeHint: 1
        }
        {
          name: 'detail_authId_d_d'
          type: 'real'
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
          dataTypeHint: 1
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
          type: 'real'
        }
        {
          name: 'detail_objectLastSeen_d_d'
          type: 'real'
        }
        {
          name: 'detail_objectRegType_d_d'
          type: 'real'
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
          type: 'real'
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
          name: 'detail_engineOperation_s'
          type: 'string'
        }
        {
          name: 'detail_eventTime_d_d'
          type: 'real'
        }
        {
          name: 'detail_integrityLevel_d_d'
          type: 'real'
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
          type: 'real'
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
          name: 'detail_instanceId_g'
          type: 'string'
        }
        {
          name: 'detail_policyId_s'
          type: 'string'
        }
        {
          name: 'detail_riskLevel_s'
          type: 'string'
        }
        {
          name: 'detail_objectTrueType_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_parentFileHashId_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_objectSigner_s'
          type: 'string'
        }
        {
          name: 'detail_objectSessionId_d'
          type: 'real'
        }
        {
          name: 'detail_objectRunAsLocalAccount_b'
          type: 'boolean'
        }
        {
          name: 'detail_integrityLevel_d'
          type: 'real'
        }
        {
          name: 'detail_lastSeen_t'
          type: 'dateTime'
        }
        {
          name: 'detail_objectAuthId_d'
          type: 'real'
        }
        {
          name: 'detail_objectFileCreation_d'
          type: 'real'
        }
        {
          name: 'detail_objectFileHashId_d'
          type: 'real'
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
          name: 'detail_objectFileHashSha256_s'
          type: 'string'
        }
        {
          name: 'detail_objectFileModifiedTime_d'
          type: 'real'
        }
        {
          name: 'detail_objectFileSize_d'
          type: 'real'
        }
        {
          name: 'detail_objectHashId_d'
          type: 'real'
        }
        {
          name: 'detail_objectIntegrityLevel_d'
          type: 'real'
        }
        {
          name: 'detail_objectLaunchTime_d'
          type: 'real'
        }
        {
          name: 'detail_objectName_s'
          type: 'string'
        }
        {
          name: 'detail_objectPid_d'
          type: 'real'
        }
        {
          name: 'detail_parentFileModifiedTime_d'
          type: 'real'
        }
        {
          name: 'detail_firstSeen_t'
          type: 'dateTime'
        }
        {
          name: 'detail_parentFilePath_s'
          type: 'string'
        }
        {
          name: 'detail_parentHashId_d'
          type: 'real'
        }
        {
          name: 'detail_processFileSize_d'
          type: 'real'
        }
        {
          name: 'detail_processHashId_d'
          type: 'real'
        }
        {
          name: 'detail_processLaunchTime_d'
          type: 'real'
        }
        {
          name: 'detail_processName_s'
          type: 'string'
        }
        {
          name: 'detail_processPid_d'
          type: 'real'
        }
        {
          name: 'detail_processSigner_s'
          type: 'string'
        }
        {
          name: 'detail_processFileModifiedTime_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_timezone_s'
          type: 'string'
        }
        {
          name: 'detail_processTrueType_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_parentLaunchTime_d'
          type: 'real'
        }
        {
          name: 'detail_parentName_s'
          type: 'string'
        }
        {
          name: 'detail_parentPid_d'
          type: 'real'
        }
        {
          name: 'detail_parentSessionId_d'
          type: 'real'
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
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'detail_pname_s'
          type: 'string'
        }
        {
          name: 'detail_pplat_d'
          type: 'real'
        }
        {
          name: 'detail_processFileCreation_d'
          type: 'real'
        }
        {
          name: 'detail_processFileHashId_d'
          type: 'real'
        }
        {
          name: 'detail_parentFileSize_d'
          type: 'real'
        }
        {
          name: 'detail_severity_d_s'
          type: 'string'
        }
        {
          name: 'detail_filterRiskLevel_s'
          type: 'string'
        }
        {
          name: 'detail_eventTime_d'
          type: 'real'
        }
        {
          name: 'detail_logKey_s'
          type: 'string'
        }
        {
          name: 'detail_mDevice_s'
          type: 'string'
        }
        {
          name: 'detail_mDeviceGUID_g'
          type: 'string'
          dataTypeHint: 1
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
          name: 'detail_interestedIp_s'
          type: 'string'
        }
        {
          name: 'detail_malType_s'
          type: 'string'
        }
        {
          name: 'detail_mpver_s'
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
          type: 'dateTime'
        }
        {
          name: 'detail_rtDate_s'
          type: 'string'
        }
        {
          name: 'detail_rtHour_d'
          type: 'real'
        }
        {
          name: 'detail_mpname_s'
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
          name: 'detail_firstAct_s'
          type: 'string'
        }
        {
          name: 'detail_ruleId_d'
          type: 'real'
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
          dataTypeHint: 1
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
          dataTypeHint: 1
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
          type: 'real'
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
          name: 'detail_rtWeekDay_s'
          type: 'string'
        }
        {
          name: 'detail_eventTimeDT_t'
          type: 'dateTime'
        }
        {
          name: 'detail_rt_utc_t'
          type: 'dateTime'
        }
        {
          name: 'detail_scanType_s'
          type: 'string'
        }
        {
          name: 'detail_endpointHostName_s'
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
          name: 'endpoint_ips_s'
          type: 'string'
        }
        {
          name: 'detail_objectFilePath_s'
          type: 'string'
        }
        {
          name: 'detail_tags_s'
          type: 'string'
        }
        {
          name: 'detail_endpointGuid_g'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_authId_d'
          type: 'real'
        }
        {
          name: 'detail_endpointMacAddress_s'
          type: 'string'
        }
        {
          name: 'detail_eventHashId_d'
          type: 'real'
        }
        {
          name: 'detail_eventId_s'
          type: 'string'
        }
        {
          name: 'detail_objectCmd_s'
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
          name: 'detail_objectRegistryRoot_d'
          type: 'real'
        }
        {
          name: 'detail_secondAct_s'
          type: 'string'
        }
        {
          name: 'detail_secondActResult_s'
          type: 'string'
        }
        {
          name: 'detail_senderGUID_g'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_senderIp_s'
          type: 'string'
        }
        {
          name: 'detail_severity_d'
          type: 'real'
        }
        {
          name: 'detail_deviceType_s'
          type: 'string'
        }
        {
          name: 'detail_nativeDeviceCharacteristics_d'
          type: 'real'
        }
        {
          name: 'detail_nativeDeviceType_d'
          type: 'real'
        }
        {
          name: 'detail_nativeStorageDeviceBusType_d'
          type: 'real'
        }
        {
          name: 'detail_objectSubTrueType_d'
          type: 'real'
        }
        {
          name: 'detail_objectFirstSeen_d'
          type: 'real'
        }
        {
          name: 'detail_objectLastSeen_d'
          type: 'real'
        }
        {
          name: 'detail_objectRegType_d'
          type: 'real'
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
          name: 'detail_ruleName_s'
          type: 'string'
        }
        {
          name: 'detail_senderIp_s_s'
          type: 'string'
        }
        {
          name: 'detail_senderGUID_g_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_secondActResult_s_s'
          type: 'string'
        }
        {
          name: 'processFileCreation_s'
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
          name: 'processCmd_s'
          type: 'string'
        }
        {
          name: 'processName_s'
          type: 'string'
        }
        {
          name: 'processSigner_s'
          type: 'real'
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
          name: 'processPid_d'
          type: 'string'
        }
        {
          name: 'pname_s'
          type: 'string'
        }
        {
          name: 'parentUserDomain_s'
          type: 'string'
        }
        {
          name: 'parentUser_s'
          type: 'string'
        }
        {
          name: 'parentFileHashMd5_g'
          type: 'string'
        }
        {
          name: 'parentFileHashSha1_s'
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
          type: 'real'
        }
        {
          name: 'parentLaunchTime_s'
          type: 'string'
        }
        {
          name: 'parentName_s'
          type: 'string'
        }
        {
          name: 'parentPid_d'
          type: 'real'
        }
        {
          name: 'parentSessionId_d'
          type: 'real'
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
          type: 'real'
        }
        {
          name: 'RawData'
          type: 'string'
        }
        {
          name: 'parentFileHashId_s'
          type: 'string'
        }
        {
          name: 'searchDL_s'
          type: 'string'
        }
        {
          name: 'source_s'
          type: 'real'
        }
        {
          name: 'detail_score_s'
          type: 'string'
        }
        {
          name: 'detail_providerGUID_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_instanceId_s'
          type: 'string'
        }
        {
          name: 'detail_deviceGUID_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_endpointGUID_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_mDeviceGUID_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detailessionId_s'
          type: 'string'
        }
        {
          name: 'detail_senderGUID_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_objectFileHashMd5_s'
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
          name: 'detail_severity_s'
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
          name: 'detail_eventTimeDT_t_UTC_s'
          type: 'string'
        }
        {
          name: 'SourceSystem'
          type: 'string'
        }
        {
          name: 'tags_s'
          type: 'string'
        }
        {
          name: 'TenantId'
          type: 'guid'
          dataTypeHint: 1
        }
        {
          name: 'timezone_s'
          type: 'dateTime'
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
          dataTypeHint: 1
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
          dataTypeHint: 1
        }
        {
          name: 'detectionTime_t_UTC_s'
          type: 'string'
        }
        {
          name: 'sessionId_d'
          type: 'string'
        }
        {
          name: 'detectionTime_UTC__s'
          type: 'string'
        }
        {
          name: 'parentFileCreation_s'
          type: 'string'
        }
        {
          name: 'parentAuthId_s'
          type: 'string'
        }
        {
          name: 'filters_s'
          type: 'string'
        }
        {
          name: 'firstSeen_s'
          type: 'string'
        }
        {
          name: 'ingestionTime_t'
          type: 'dateTime'
        }
        {
          name: 'integrityLevel_d'
          type: 'real'
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
          name: 'filterRiskLevel_s'
          type: 'string'
        }
        {
          name: 'ManagementGroupName'
          type: 'string'
        }
        {
          name: 'nativeDeviceCharacteristics_d'
          type: 'real'
        }
        {
          name: 'nativeDeviceType_d'
          type: 'real'
        }
        {
          name: 'nativeStorageDeviceBusType_d'
          type: 'real'
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
          name: 'MG'
          type: 'string'
        }
        {
          name: 'eventTime_d'
          type: 'real'
        }
        {
          name: 'eventSubId_d'
          type: 'real'
        }
        {
          name: 'eventSourceType_d'
          type: 'real'
        }
        {
          name: '_ItemId'
          type: 'string'
        }
        {
          name: 'authId_s'
          type: 'string'
        }
        {
          name: 'bitwiseFilterRiskLevel_d'
          type: 'real'
        }
        {
          name: 'Computer'
          type: 'string'
        }
        {
          name: 'detectionTime_t'
          type: 'dateTime'
        }
        {
          name: 'deviceType_d'
          type: 'real'
        }
        {
          name: 'endpoint_guid_g'
          type: 'string'
          dataTypeHint: 1
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
          name: 'objectContentName_s'
          type: 'string'
        }
        {
          name: 'parentCmd_s'
          type: 'string'
        }
        {
          name: 'objectFileCreation_s'
          type: 'string'
        }
        {
          name: 'objectFileHashId_s'
          type: 'string'
        }
        {
          name: 'objectRegType_d'
          type: 'real'
        }
        {
          name: 'objectRunAsLocalAccount_b'
          type: 'boolean'
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
          type: 'real'
        }
        {
          name: 'objectRegistryValue_s'
          type: 'string'
        }
        {
          name: 'objectTrueType_d'
          type: 'real'
        }
        {
          name: 'objectUserDomain_s'
          type: 'string'
        }
        {
          name: 'os_s'
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
          name: 'objectUser_s'
          type: 'string'
        }
        {
          name: 'objectRegistryRoot_d'
          type: 'real'
        }
        {
          name: 'objectRegistryKeyHandle_s'
          type: 'string'
        }
        {
          name: 'objectRegistryData_s'
          type: 'string'
        }
        {
          name: 'objectFileHashMd5_g'
          type: 'string'
        }
        {
          name: 'objectFileHashSha1_s'
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
          type: 'real'
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
          type: 'real'
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
          name: 'objectFileDaclString_s'
          type: 'string'
        }
        {
          name: 'detail_userDomain_s'
          type: 'string'
        }
        {
          name: 'detail_eventTimeDT_UTC__s'
          type: 'string'
        }
        {
          name: 'detail_lastSeen_UTC__s'
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
          name: 'detail_rawDataSize_d_s'
          type: 'string'
        }
        {
          name: 'detail_providerName_s_s'
          type: 'string'
        }
        {
          name: 'detail_providerGUID_g_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_cccaRiskLevel_d_s'
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
          name: 'detail_urlCat_s_s'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'detail_patType_s_s'
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
          name: 'detail_riskLevel_s_s'
          type: 'string'
        }
        {
          name: 'detail_cccaDetectionSource_s_s'
          type: 'string'
        }
        {
          name: 'detail_ruleId_d_s'
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
          dataTypeHint: 1
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
          dataTypeHint: 1
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
          dataTypeHint: 1
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
          name: 'detail_actResult_s_s'
          type: 'string'
        }
        {
          name: 'detail_firstSeen_UTC__s'
          type: 'string'
        }
        {
          name: 'detail_blocking_s_s'
          type: 'string'
        }
        {
          name: 'TimeGenerated_UTC__s'
          type: 'string'
        }
        {
          name: 'detail_rtHour_s'
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
          dataTypeHint: 1
        }
        {
          name: 'detail_rt_t_UTC__s'
          type: 'string'
        }
        {
          name: 'detailenderIp_s'
          type: 'string'
        }
        {
          name: 'detaileviceType_s'
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
          name: 'detaileverity_s'
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
          name: 'detaileviceGUID_g_s'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'TimeGenerated_UTC_s'
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
          name: 'detectionTime_t_UTC__s'
          type: 'string'
        }
        {
          name: 'detail_app_s_s'
          type: 'string'
        }
        {
          name: 'endpoint_guid_g_g_g'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_eventHashId_s'
          type: 'string'
        }
        {
          name: 'detail_parentFileSize_s'
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
          name: 'detail_parentFileModifiedTime_s'
          type: 'string'
        }
        {
          name: 'detail_parentTrueType_s'
          type: 'string'
        }
        {
          name: 'detail_processFileHashId_s'
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
          type: 'real'
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
          name: 'detail_pname_d'
          type: 'real'
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
          name: 'detail_parentAuthId_s'
          type: 'string'
        }
        {
          name: 'detail_eventTimeDT_t_UTC__s'
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
          type: 'real'
        }
        {
          name: 'detail_endpointGuid_g_g_g'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'detail_uuid_g'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = trendmicroxdroatclTable.name
output tableId string = trendmicroxdroatclTable.id
output provisioningState string = trendmicroxdroatclTable.properties.provisioningState
