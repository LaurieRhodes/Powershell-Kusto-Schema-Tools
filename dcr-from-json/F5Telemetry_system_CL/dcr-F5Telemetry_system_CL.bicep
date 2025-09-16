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
// Data Collection Rule for F5Telemetry_system_CL
// ============================================================================
// Generated: 2025-09-17 06:20:55
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns included
// Original columns: 14, DCR columns: 13 (Type column always filtered)
// Output stream: Custom-F5Telemetry_system_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-F5Telemetry_system_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-F5Telemetry_system_CL': {
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
            name: 'SourceSystem'
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
            name: 'Computer'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
          {
            name: 'probability'
            type: 'string'
          }
          {
            name: 'RawMessage'
            type: 'string'
          }
          {
            name: 'client_ip_s'
            type: 'string'
          }
          {
            name: 'hostname_s'
            type: 'string'
          }
          {
            name: 'geo_location_s'
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
          name: 'Sentinel-F5Telemetry_system_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-F5Telemetry_system_CL']
        destinations: ['Sentinel-F5Telemetry_system_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), SourceSystem = tostring(SourceSystem), MG = tostring(MG), ManagementGroupName = tostring(ManagementGroupName), Computer = tostring(Computer), RawData = tostring(RawData), probability = toreal(probability), RawMessage = tostring(RawMessage), client_ip_s = tostring(client_ip_s), hostname_s = tostring(hostname_s), geo_location_s = tostring(geo_location_s), _ResourceId = tostring(_ResourceId)'
        outputStream: 'Custom-F5Telemetry_system_CL'
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
