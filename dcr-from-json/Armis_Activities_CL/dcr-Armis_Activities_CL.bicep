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
// Data Collection Rule for Armis_Activities_CL
// ============================================================================
// Generated: 2025-09-17 06:20:41
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 20, DCR columns: 18 (Type column always filtered)
// Output stream: Custom-Armis_Activities_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-Armis_Activities_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-Armis_Activities_CL': {
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
            name: 'SiteName'
            type: 'string'
          }
          {
            name: 'SiteLocation'
            type: 'string'
          }
          {
            name: 'SensorType'
            type: 'string'
          }
          {
            name: 'SensorName'
            type: 'string'
          }
          {
            name: 'Protocol'
            type: 'string'
          }
          {
            name: 'Content'
            type: 'string'
          }
          {
            name: 'Title'
            type: 'string'
          }
          {
            name: 'ActivityUUID'
            type: 'string'
          }
          {
            name: 'EventVendor'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
          {
            name: 'Computer'
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
            name: 'SourceSystem'
            type: 'string'
          }
          {
            name: 'EventProduct'
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
          name: 'Sentinel-Armis_Activities_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-Armis_Activities_CL']
        destinations: ['Sentinel-Armis_Activities_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), SiteName = tostring(SiteName), SiteLocation = tostring(SiteLocation), SensorType = tostring(SensorType), SensorName = tostring(SensorName), Protocol = tostring(Protocol), Content = tostring(Content), Title = tostring(Title), ActivityUUID = tostring(ActivityUUID), EventVendor = tostring(EventVendor), RawData = tostring(RawData), Computer = tostring(Computer), ManagementGroupName = tostring(ManagementGroupName), MG = tostring(MG), SourceSystem = tostring(SourceSystem), EventProduct = tostring(EventProduct), _ResourceId = tostring(_ResourceId)'
        outputStream: 'Custom-Armis_Activities_CL'
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
