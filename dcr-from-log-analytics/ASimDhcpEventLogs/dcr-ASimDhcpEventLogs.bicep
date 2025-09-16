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
// Data Collection Rule for ASimDhcpEventLogs
// ============================================================================
// Generated: 2025-09-17 08:12:39
// Table type: Microsoft
// Schema discovered using hybrid approach (Management API + getschema)
// Underscore columns included
// Original columns: 98, DCR columns: 97 (Type column always filtered)
// Input stream: Custom-ASimDhcpEventLogs (always Custom- for JSON ingestion)
// Output stream: Custom-ASimDhcpEventLogs (based on table type)
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-ASimDhcpEventLogs'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-ASimDhcpEventLogs': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: 'TenantId'
            type: 'string'
          }
          {
            name: 'SrcGeoCountry'
            type: 'string'
          }
          {
            name: 'SrcUserUid'
            type: 'string'
          }
          {
            name: 'SrcUserType'
            type: 'string'
          }
          {
            name: 'SrcUserSessionId'
            type: 'string'
          }
          {
            name: 'SrcUserScopeId'
            type: 'string'
          }
          {
            name: 'SrcUserScope'
            type: 'string'
          }
          {
            name: 'SrcUsernameType'
            type: 'string'
          }
          {
            name: 'SrcUsername'
            type: 'string'
          }
          {
            name: 'SrcUserIdType'
            type: 'string'
          }
          {
            name: 'SrcGeoLatitude'
            type: 'string'
          }
          {
            name: 'SrcUserId'
            type: 'string'
          }
          {
            name: 'SrcOriginalUserType'
            type: 'string'
          }
          {
            name: 'SrcDescription'
            type: 'string'
          }
          {
            name: 'SrcFQDN'
            type: 'string'
          }
          {
            name: 'SrcDvcScopeId'
            type: 'string'
          }
          {
            name: 'SrcDvcScope'
            type: 'string'
          }
          {
            name: 'SrcDvcIdType'
            type: 'string'
          }
          {
            name: 'SrcDvcId'
            type: 'string'
          }
          {
            name: 'SrcDomainType'
            type: 'string'
          }
          {
            name: 'SrcDeviceType'
            type: 'string'
          }
          {
            name: 'SrcPortNumber'
            type: 'string'
          }
          {
            name: 'RequestedIpAddr'
            type: 'string'
          }
          {
            name: 'SrcGeoLongitude'
            type: 'string'
          }
          {
            name: 'SrcGeoCity'
            type: 'string'
          }
          {
            name: 'AdditionalFields'
            type: 'dynamic'
          }
          {
            name: 'EventEndTime'
            type: 'string'
          }
          {
            name: 'EventStartTime'
            type: 'string'
          }
          {
            name: 'EventSchemaVersion'
            type: 'string'
          }
          {
            name: 'EventSchema'
            type: 'string'
          }
          {
            name: 'ThreatLastReportedTime'
            type: 'string'
          }
          {
            name: 'ThreatFirstReportedTime'
            type: 'string'
          }
          {
            name: 'ThreatIsActive'
            type: 'string'
          }
          {
            name: 'ThreatOriginalConfidence'
            type: 'string'
          }
          {
            name: 'SrcGeoRegion'
            type: 'string'
          }
          {
            name: 'ThreatConfidence'
            type: 'string'
          }
          {
            name: 'ThreatOriginalRiskLevel'
            type: 'string'
          }
          {
            name: 'ThreatRiskLevel'
            type: 'string'
          }
          {
            name: 'ThreatCategory'
            type: 'string'
          }
          {
            name: 'ThreatName'
            type: 'string'
          }
          {
            name: 'ThreatId'
            type: 'string'
          }
          {
            name: 'RuleNumber'
            type: 'string'
          }
          {
            name: 'RuleName'
            type: 'string'
          }
          {
            name: 'SrcOriginalRiskLevel'
            type: 'string'
          }
          {
            name: 'SrcRiskLevel'
            type: 'string'
          }
          {
            name: 'ThreatField'
            type: 'string'
          }
          {
            name: 'EventSubType'
            type: 'string'
          }
          {
            name: 'EventReportUrl'
            type: 'string'
          }
          {
            name: 'EventProductVersion'
            type: 'string'
          }
          {
            name: 'DvcIpAddr'
            type: 'string'
          }
          {
            name: 'EventResultDetails'
            type: 'string'
          }
          {
            name: 'DhcpVendorClassId'
            type: 'string'
          }
          {
            name: 'DhcpVendorClass'
            type: 'string'
          }
          {
            name: 'DhcpUserClassId'
            type: 'string'
          }
          {
            name: 'DhcpUserClass'
            type: 'string'
          }
          {
            name: 'DhcpSubscriberId'
            type: 'string'
          }
          {
            name: 'DhcpSrcDHCId'
            type: 'string'
          }
          {
            name: 'DhcpSessionId'
            type: 'string'
          }
          {
            name: 'DvcHostname'
            type: 'string'
          }
          {
            name: 'DhcpSessionDuration'
            type: 'string'
          }
          {
            name: 'DhcpCircuitId'
            type: 'string'
          }
          {
            name: 'SrcMacAddr'
            type: 'string'
          }
          {
            name: 'SrcIpAddr'
            type: 'string'
          }
          {
            name: 'SrcHostname'
            type: 'string'
          }
          {
            name: 'EventType'
            type: 'string'
          }
          {
            name: 'EventSeverity'
            type: 'string'
          }
          {
            name: 'EventResult'
            type: 'string'
          }
          {
            name: 'EventVendor'
            type: 'string'
          }
          {
            name: 'EventProduct'
            type: 'string'
          }
          {
            name: 'DhcpLeaseDuration'
            type: 'string'
          }
          {
            name: 'DvcAction'
            type: 'string'
          }
          {
            name: 'DvcDescription'
            type: 'string'
          }
          {
            name: 'DvcDomain'
            type: 'string'
          }
          {
            name: 'EventOwner'
            type: 'string'
          }
          {
            name: 'EventOriginalUid'
            type: 'string'
          }
          {
            name: 'EventOriginalType'
            type: 'string'
          }
          {
            name: 'EventOriginalSubType'
            type: 'string'
          }
          {
            name: 'EventOriginalSeverity'
            type: 'string'
          }
          {
            name: 'EventOriginalResultDetails'
            type: 'string'
          }
          {
            name: 'EventMessage'
            type: 'string'
          }
          {
            name: 'EventCount'
            type: 'string'
          }
          {
            name: 'SrcDomain'
            type: 'string'
          }
          {
            name: 'DvcZone'
            type: 'string'
          }
          {
            name: 'DvcScopeId'
            type: 'string'
          }
          {
            name: 'DvcScope'
            type: 'string'
          }
          {
            name: 'DvcOsVersion'
            type: 'string'
          }
          {
            name: 'DvcOs'
            type: 'string'
          }
          {
            name: 'DvcOriginalAction'
            type: 'string'
          }
          {
            name: 'DvcMacAddr'
            type: 'string'
          }
          {
            name: 'DvcInterface'
            type: 'string'
          }
          {
            name: 'DvcIdType'
            type: 'string'
          }
          {
            name: 'DvcId'
            type: 'string'
          }
          {
            name: 'DvcFQDN'
            type: 'string'
          }
          {
            name: 'DvcDomainType'
            type: 'string'
          }
          {
            name: 'SourceSystem'
            type: 'string'
          }
          {
            name: '_ResourceId'
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
          name: 'Sentinel-ASimDhcpEventLogs'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-ASimDhcpEventLogs']
        destinations: ['Sentinel-ASimDhcpEventLogs']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), SrcGeoCountry = tostring(SrcGeoCountry), SrcUserUid = tostring(SrcUserUid), SrcUserType = tostring(SrcUserType), SrcUserSessionId = tostring(SrcUserSessionId), SrcUserScopeId = tostring(SrcUserScopeId), SrcUserScope = tostring(SrcUserScope), SrcUsernameType = tostring(SrcUsernameType), SrcUsername = tostring(SrcUsername), SrcUserIdType = tostring(SrcUserIdType), SrcGeoLatitude = toreal(SrcGeoLatitude), SrcUserId = tostring(SrcUserId), SrcOriginalUserType = tostring(SrcOriginalUserType), SrcDescription = tostring(SrcDescription), SrcFQDN = tostring(SrcFQDN), SrcDvcScopeId = tostring(SrcDvcScopeId), SrcDvcScope = tostring(SrcDvcScope), SrcDvcIdType = tostring(SrcDvcIdType), SrcDvcId = tostring(SrcDvcId), SrcDomainType = tostring(SrcDomainType), SrcDeviceType = tostring(SrcDeviceType), SrcPortNumber = toint(SrcPortNumber), RequestedIpAddr = tostring(RequestedIpAddr), SrcGeoLongitude = toreal(SrcGeoLongitude), SrcGeoCity = tostring(SrcGeoCity), AdditionalFields = todynamic(AdditionalFields), EventEndTime = todatetime(EventEndTime), EventStartTime = todatetime(EventStartTime), EventSchemaVersion = tostring(EventSchemaVersion), EventSchema = tostring(EventSchema), ThreatLastReportedTime = todatetime(ThreatLastReportedTime), ThreatFirstReportedTime = todatetime(ThreatFirstReportedTime), ThreatIsActive = tobool(ThreatIsActive), ThreatOriginalConfidence = tostring(ThreatOriginalConfidence), SrcGeoRegion = tostring(SrcGeoRegion), ThreatConfidence = toint(ThreatConfidence), ThreatOriginalRiskLevel = tostring(ThreatOriginalRiskLevel), ThreatRiskLevel = toint(ThreatRiskLevel), ThreatCategory = tostring(ThreatCategory), ThreatName = tostring(ThreatName), ThreatId = tostring(ThreatId), RuleNumber = toint(RuleNumber), RuleName = tostring(RuleName), SrcOriginalRiskLevel = tostring(SrcOriginalRiskLevel), SrcRiskLevel = toint(SrcRiskLevel), ThreatField = tostring(ThreatField), EventSubType = tostring(EventSubType), EventReportUrl = tostring(EventReportUrl), EventProductVersion = tostring(EventProductVersion), DvcIpAddr = tostring(DvcIpAddr), EventResultDetails = tostring(EventResultDetails), DhcpVendorClassId = tostring(DhcpVendorClassId), DhcpVendorClass = tostring(DhcpVendorClass), DhcpUserClassId = tostring(DhcpUserClassId), DhcpUserClass = tostring(DhcpUserClass), DhcpSubscriberId = tostring(DhcpSubscriberId), DhcpSrcDHCId = tostring(DhcpSrcDHCId), DhcpSessionId = tostring(DhcpSessionId), DvcHostname = tostring(DvcHostname), DhcpSessionDuration = toint(DhcpSessionDuration), DhcpCircuitId = tostring(DhcpCircuitId), SrcMacAddr = tostring(SrcMacAddr), SrcIpAddr = tostring(SrcIpAddr), SrcHostname = tostring(SrcHostname), EventType = tostring(EventType), EventSeverity = tostring(EventSeverity), EventResult = tostring(EventResult), EventVendor = tostring(EventVendor), EventProduct = tostring(EventProduct), DhcpLeaseDuration = toint(DhcpLeaseDuration), DvcAction = tostring(DvcAction), DvcDescription = tostring(DvcDescription), DvcDomain = tostring(DvcDomain), EventOwner = tostring(EventOwner), EventOriginalUid = tostring(EventOriginalUid), EventOriginalType = tostring(EventOriginalType), EventOriginalSubType = tostring(EventOriginalSubType), EventOriginalSeverity = tostring(EventOriginalSeverity), EventOriginalResultDetails = tostring(EventOriginalResultDetails), EventMessage = tostring(EventMessage), EventCount = toint(EventCount), SrcDomain = tostring(SrcDomain), DvcZone = tostring(DvcZone), DvcScopeId = tostring(DvcScopeId), DvcScope = tostring(DvcScope), DvcOsVersion = tostring(DvcOsVersion), DvcOs = tostring(DvcOs), DvcOriginalAction = tostring(DvcOriginalAction), DvcMacAddr = tostring(DvcMacAddr), DvcInterface = tostring(DvcInterface), DvcIdType = tostring(DvcIdType), DvcId = tostring(DvcId), DvcFQDN = tostring(DvcFQDN), DvcDomainType = tostring(DvcDomainType), SourceSystem = tostring(SourceSystem), _ResourceId = tostring(_ResourceId)'
        outputStream: 'Custom-ASimDhcpEventLogs'
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
