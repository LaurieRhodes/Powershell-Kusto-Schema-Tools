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
// Data Collection Rule for BetterMTDNetflowLog_CL
// ============================================================================
// Generated: 2025-09-17 06:20:44
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 36, DCR columns: 35 (Type column always filtered)
// Output stream: Custom-BetterMTDNetflowLog_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-BetterMTDNetflowLog_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-BetterMTDNetflowLog_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: '_ResourceId'
            type: 'string'
          }
          {
            name: 'UrlStatus'
            type: 'string'
          }
          {
            name: 'Url'
            type: 'string'
          }
          {
            name: 'UDID'
            type: 'string'
          }
          {
            name: 'TenantId'
            type: 'string'
          }
          {
            name: 'Status_s'
            type: 'string'
          }
          {
            name: 'SourceSystem'
            type: 'string'
          }
          {
            name: 'SourceLon'
            type: 'string'
          }
          {
            name: 'SourceLat'
            type: 'string'
          }
          {
            name: 'SourceCountryCode'
            type: 'string'
          }
          {
            name: 'SourceCountry'
            type: 'string'
          }
          {
            name: 'SourceClient'
            type: 'string'
          }
          {
            name: 'Scheme'
            type: 'string'
          }
          {
            name: 'Reason'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
          {
            name: 'Port'
            type: 'string'
          }
          {
            name: 'Path'
            type: 'string'
          }
          {
            name: 'NetworkType'
            type: 'string'
          }
          {
            name: 'Account'
            type: 'string'
          }
          {
            name: 'AppIdentifier'
            type: 'string'
          }
          {
            name: 'AppName'
            type: 'string'
          }
          {
            name: 'Cid'
            type: 'string'
          }
          {
            name: 'Computer'
            type: 'string'
          }
          {
            name: 'Destination'
            type: 'string'
          }
          {
            name: 'Username'
            type: 'string'
          }
          {
            name: 'DestinationCountry'
            type: 'string'
          }
          {
            name: 'DestinationLat'
            type: 'string'
          }
          {
            name: 'DestinationLon'
            type: 'string'
          }
          {
            name: 'DeviceName'
            type: 'string'
          }
          {
            name: 'Host'
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
            name: 'DestinationCountryCode'
            type: 'string'
          }
          {
            name: 'UUId'
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
          name: 'Sentinel-BetterMTDNetflowLog_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-BetterMTDNetflowLog_CL']
        destinations: ['Sentinel-BetterMTDNetflowLog_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), _ResourceId = tostring(_ResourceId), UrlStatus = tostring(UrlStatus), Url = tostring(Url), UDID = tostring(UDID), TenantId = toguid(TenantId), Status_s = tostring(Status_s), SourceSystem = tostring(SourceSystem), SourceLon = toreal(SourceLon), SourceLat = toreal(SourceLat), SourceCountryCode = tostring(SourceCountryCode), SourceCountry = tostring(SourceCountry), SourceClient = tostring(SourceClient), Scheme = tostring(Scheme), Reason = tostring(Reason), RawData = tostring(RawData), Port = toreal(Port), Path = tostring(Path), NetworkType = tostring(NetworkType), Account = tostring(Account), AppIdentifier = tostring(AppIdentifier), AppName = tostring(AppName), Cid = toreal(Cid), Computer = tostring(Computer), Destination = tostring(Destination), Username = tostring(Username), DestinationCountry = tostring(DestinationCountry), DestinationLat = toreal(DestinationLat), DestinationLon = toreal(DestinationLon), DeviceName = tostring(DeviceName), Host = tostring(Host), ManagementGroupName = tostring(ManagementGroupName), MG = tostring(MG), DestinationCountryCode = tostring(DestinationCountryCode), UUId = tostring(UUId)'
        outputStream: 'Custom-BetterMTDNetflowLog_CL'
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
