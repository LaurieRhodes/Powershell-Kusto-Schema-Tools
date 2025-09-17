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
// Data Collection Rule for ProofPointTAPMessagesBlocked_CL
// ============================================================================
// Generated: 2025-09-18 08:37:35
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns filtered out
// Original columns: 37, DCR columns: 35 (Type column always filtered)
// Output stream: Custom-ProofPointTAPMessagesBlocked_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-ProofPointTAPMessagesBlocked_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-ProofPointTAPMessagesBlocked_CL': {
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
            name: 'ccAddresses_s'
            type: 'string'
          }
          {
            name: 'fromAddress_s'
            type: 'string'
          }
          {
            name: 'quarantineFolder_s'
            type: 'string'
          }
          {
            name: 'cluster_s'
            type: 'string'
          }
          {
            name: 'GUID_s'
            type: 'string'
          }
          {
            name: 'modulesRun_s'
            type: 'string'
          }
          {
            name: 'policyRoutes_s'
            type: 'string'
          }
          {
            name: 'phishScore_d'
            type: 'string'
          }
          {
            name: 'headerFrom_s'
            type: 'string'
          }
          {
            name: 'messageSize_d'
            type: 'string'
          }
          {
            name: 'malwareScore_d'
            type: 'string'
          }
          {
            name: 'impostorScore_d'
            type: 'string'
          }
          {
            name: 'headerReplyTo_s'
            type: 'string'
          }
          {
            name: 'messageParts_s'
            type: 'string'
          }
          {
            name: 'messageID_s'
            type: 'string'
          }
          {
            name: 'senderIP_s'
            type: 'string'
          }
          {
            name: 'recipient_s'
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
            name: 'spamScore_d'
            type: 'string'
          }
          {
            name: 'xmailer_s'
            type: 'string'
          }
          {
            name: 'threatsInfoMap_s'
            type: 'string'
          }
          {
            name: 'subject_s'
            type: 'string'
          }
          {
            name: 'quarantineRule_s'
            type: 'string'
          }
          {
            name: 'replyToAddress_s'
            type: 'string'
          }
          {
            name: 'toAddresses_s'
            type: 'string'
          }
          {
            name: 'QID_s'
            type: 'string'
          }
          {
            name: 'sender_s'
            type: 'string'
          }
          {
            name: 'messageTime_t'
            type: 'string'
          }
          {
            name: 'completelyRewritten_b'
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
          name: 'Sentinel-ProofPointTAPMessagesBlocked_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-ProofPointTAPMessagesBlocked_CL']
        destinations: ['Sentinel-ProofPointTAPMessagesBlocked_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), ccAddresses_s = tostring(ccAddresses_s), fromAddress_s = tostring(fromAddress_s), quarantineFolder_s = tostring(quarantineFolder_s), cluster_s = tostring(cluster_s), GUID_s = tostring(GUID_s), modulesRun_s = tostring(modulesRun_s), policyRoutes_s = tostring(policyRoutes_s), phishScore_d = toreal(phishScore_d), headerFrom_s = tostring(headerFrom_s), messageSize_d = toreal(messageSize_d), malwareScore_d = toreal(malwareScore_d), impostorScore_d = toreal(impostorScore_d), headerReplyTo_s = tostring(headerReplyTo_s), messageParts_s = tostring(messageParts_s), messageID_s = tostring(messageID_s), senderIP_s = tostring(senderIP_s), recipient_s = tostring(recipient_s), SourceSystem = tostring(SourceSystem), MG = tostring(MG), ManagementGroupName = tostring(ManagementGroupName), Computer = tostring(Computer), RawData = tostring(RawData), spamScore_d = toreal(spamScore_d), xmailer_s = tostring(xmailer_s), threatsInfoMap_s = tostring(threatsInfoMap_s), subject_s = tostring(subject_s), quarantineRule_s = tostring(quarantineRule_s), replyToAddress_s = tostring(replyToAddress_s), toAddresses_s = tostring(toAddresses_s), QID_s = tostring(QID_s), sender_s = tostring(sender_s), messageTime_t = todatetime(messageTime_t), completelyRewritten_b = tobool(completelyRewritten_b)'
        outputStream: 'Custom-ProofPointTAPMessagesBlocked_CL'
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
