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
// Data Collection Rule for ESETInspect_CL
// ============================================================================
// Generated: 2025-09-18 08:37:29
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns filtered out
// Original columns: 40, DCR columns: 38 (Type column always filtered)
// Output stream: Custom-ESETInspect_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-ESETInspect_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-ESETInspect_CL': {
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
            name: 'moduleLgReputation_d'
            type: 'string'
          }
          {
            name: 'moduleName_s'
            type: 'string'
          }
          {
            name: 'moduleSha1_s'
            type: 'string'
          }
          {
            name: 'moduleSignatureType_s'
            type: 'string'
          }
          {
            name: 'moduleSigner_s'
            type: 'string'
          }
          {
            name: 'priority_d'
            type: 'string'
          }
          {
            name: 'processCommandLine_s'
            type: 'string'
          }
          {
            name: 'processId_d'
            type: 'string'
          }
          {
            name: 'processPath_s'
            type: 'string'
          }
          {
            name: 'processUser_s'
            type: 'string'
          }
          {
            name: 'resolved_b'
            type: 'string'
          }
          {
            name: 'ruleName_s'
            type: 'string'
          }
          {
            name: 'severityScore_d'
            type: 'string'
          }
          {
            name: 'threatName_s'
            type: 'string'
          }
          {
            name: 'threatUri_s'
            type: 'string'
          }
          {
            name: 'moduleLgPopularity_d'
            type: 'string'
          }
          {
            name: 'type_s'
            type: 'string'
          }
          {
            name: 'moduleLgAge_d'
            type: 'string'
          }
          {
            name: 'moduleId_d'
            type: 'string'
          }
          {
            name: 'SourceSystem'
            type: 'string'
          }
          {
            name: 'Computer'
            type: 'string'
          }
          {
            name: 'MG'
            type: 'string'
          }
          {
            name: 'ManagementGroupName'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
          {
            name: 'Severity'
            type: 'string'
          }
          {
            name: 'TableName'
            type: 'string'
          }
          {
            name: 'computerId_d'
            type: 'string'
          }
          {
            name: 'computerName_s'
            type: 'string'
          }
          {
            name: 'computerUuid_g'
            type: 'string'
          }
          {
            name: 'creationTime_t'
            type: 'string'
          }
          {
            name: 'deepLink_s'
            type: 'string'
          }
          {
            name: 'handled_d'
            type: 'string'
          }
          {
            name: 'id_d'
            type: 'string'
          }
          {
            name: 'moduleFirstSeenLocally_t'
            type: 'string'
          }
          {
            name: 'moduleLastExecutedLocally_t'
            type: 'string'
          }
          {
            name: 'uuid_g'
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
          name: 'Sentinel-ESETInspect_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-ESETInspect_CL']
        destinations: ['Sentinel-ESETInspect_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), moduleLgReputation_d = toreal(moduleLgReputation_d), moduleName_s = tostring(moduleName_s), moduleSha1_s = tostring(moduleSha1_s), moduleSignatureType_s = tostring(moduleSignatureType_s), moduleSigner_s = tostring(moduleSigner_s), priority_d = toreal(priority_d), processCommandLine_s = tostring(processCommandLine_s), processId_d = toreal(processId_d), processPath_s = tostring(processPath_s), processUser_s = tostring(processUser_s), resolved_b = tobool(resolved_b), ruleName_s = tostring(ruleName_s), severityScore_d = toreal(severityScore_d), threatName_s = tostring(threatName_s), threatUri_s = tostring(threatUri_s), moduleLgPopularity_d = toreal(moduleLgPopularity_d), type_s = tostring(type_s), moduleLgAge_d = toreal(moduleLgAge_d), moduleId_d = toreal(moduleId_d), SourceSystem = tostring(SourceSystem), Computer = tostring(Computer), MG = tostring(MG), ManagementGroupName = tostring(ManagementGroupName), RawData = tostring(RawData), Severity = tostring(Severity), TableName = tostring(TableName), computerId_d = toreal(computerId_d), computerName_s = tostring(computerName_s), computerUuid_g = tostring(computerUuid_g), creationTime_t = todatetime(creationTime_t), deepLink_s = tostring(deepLink_s), handled_d = toreal(handled_d), id_d = toreal(id_d), moduleFirstSeenLocally_t = tostring(moduleFirstSeenLocally_t), moduleLastExecutedLocally_t = tostring(moduleLastExecutedLocally_t), uuid_g = tostring(uuid_g)'
        outputStream: 'Custom-ESETInspect_CL'
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
