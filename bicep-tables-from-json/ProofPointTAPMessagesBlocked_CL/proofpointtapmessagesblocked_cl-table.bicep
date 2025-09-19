// Bicep template for Log Analytics custom table: ProofPointTAPMessagesBlocked_CL
// Generated on 2025-09-19 14:13:57 UTC
// Source: JSON schema export
// Original columns: 37, Deployed columns: 35 (Type column filtered)
// Underscore columns filtered out
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

resource proofpointtapmessagesblockedclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'ProofPointTAPMessagesBlocked_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'ProofPointTAPMessagesBlocked_CL'
      description: 'Custom table ProofPointTAPMessagesBlocked_CL - imported from JSON schema'
      displayName: 'ProofPointTAPMessagesBlocked_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'TenantId'
          type: 'guid'
          dataTypeHint: 1
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
          type: 'real'
        }
        {
          name: 'headerFrom_s'
          type: 'string'
        }
        {
          name: 'messageSize_d'
          type: 'real'
        }
        {
          name: 'malwareScore_d'
          type: 'real'
        }
        {
          name: 'impostorScore_d'
          type: 'real'
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
          type: 'real'
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
          type: 'dateTime'
        }
        {
          name: 'completelyRewritten_b'
          type: 'boolean'
        }
      ]
    }
  }
}

output tableName string = proofpointtapmessagesblockedclTable.name
output tableId string = proofpointtapmessagesblockedclTable.id
output provisioningState string = proofpointtapmessagesblockedclTable.properties.provisioningState
