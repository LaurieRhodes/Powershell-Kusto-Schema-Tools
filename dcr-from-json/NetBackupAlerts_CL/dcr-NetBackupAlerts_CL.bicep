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
// Data Collection Rule for NetBackupAlerts_CL
// ============================================================================
// Generated: 2025-09-17 06:20:58
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 18, DCR columns: 17 (Type column always filtered)
// Output stream: Custom-NetBackupAlerts_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-NetBackupAlerts_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-NetBackupAlerts_CL': {
        columns: [
          {
            name: 'TenantId'
            type: 'string'
          }
          {
            name: 'reason_s'
            type: 'string'
          }
          {
            name: 'auditDateTime_t [UTC]'
            type: 'string'
          }
          {
            name: 'userName_s'
            type: 'string'
          }
          {
            name: 'Message'
            type: 'string'
          }
          {
            name: 'operation_s'
            type: 'string'
          }
          {
            name: 'Category'
            type: 'string'
          }
          {
            name: 'auditAttributes_s'
            type: 'string'
          }
          {
            name: 'auditDateTime_d'
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
            name: 'TimeGenerated [UTC]'
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
            name: 'tenantId_g'
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
          name: 'Sentinel-NetBackupAlerts_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-NetBackupAlerts_CL']
        destinations: ['Sentinel-NetBackupAlerts_CL']
        transformKql: 'source | project TenantId = toguid(TenantId), reason_s = tostring(reason_s), auditDateTime_t [UTC] = todatetime(auditDateTime_t [UTC]), userName_s = tostring(userName_s), Message = tostring(Message), operation_s = tostring(operation_s), Category = tostring(Category), auditAttributes_s = tostring(auditAttributes_s), auditDateTime_d = tostring(auditDateTime_d), RawData = tostring(RawData), Computer = tostring(Computer), TimeGenerated [UTC] = todatetime(TimeGenerated [UTC]), ManagementGroupName = tostring(ManagementGroupName), MG = tostring(MG), SourceSystem = tostring(SourceSystem), tenantId_g = tostring(tenantId_g), _ResourceId = tostring(_ResourceId)'
        outputStream: 'Custom-NetBackupAlerts_CL'
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
