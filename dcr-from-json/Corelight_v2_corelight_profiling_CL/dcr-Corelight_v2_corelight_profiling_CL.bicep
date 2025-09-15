﻿@description('The location of the resources')
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
// Data Collection Rule for Corelight_v2_corelight_profiling_CL
// ============================================================================
// Generated: 2025-09-13 20:13:33
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Original columns: 9, DCR columns: 6 (Type column filtered out)
// Output stream: Custom-Corelight_v2_corelight_profiling_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-Corelight_v2_corelight_profiling_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-Corelight_v2_corelight_profiling_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: 'ts_t'
            type: 'string'
          }
          {
            name: 'node_s'
            type: 'string'
          }
          {
            name: 'prof_core_stack_s'
            type: 'string'
          }
          {
            name: 'prof_script_stack_s'
            type: 'string'
          }
          {
            name: 'prof_sched_wait_ns_d'
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
          name: 'Sentinel-Corelight_v2_corelight_profiling_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-Corelight_v2_corelight_profiling_CL']
        destinations: ['Sentinel-Corelight_v2_corelight_profiling_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), ts_t = todatetime(ts_t), node_s = tostring(node_s), prof_core_stack_s = tostring(prof_core_stack_s), prof_script_stack_s = tostring(prof_script_stack_s), prof_sched_wait_ns_d = toreal(prof_sched_wait_ns_d)'
        outputStream: 'Custom-Corelight_v2_corelight_profiling_CL'
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
