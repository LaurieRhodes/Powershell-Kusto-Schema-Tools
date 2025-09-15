﻿// Bicep template for Log Analytics custom table: WebSession_Summarized_ThreatInfo_CL
// Generated on 2025-09-13 20:15:29 UTC
// Source: JSON schema export
// Original columns: 17, Deployed columns: 17 (only 'Type' filtered out)
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

resource websessionsummarizedthreatinfoclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'WebSession_Summarized_ThreatInfo_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'WebSession_Summarized_ThreatInfo_CL'
      description: 'Custom table WebSession_Summarized_ThreatInfo_CL - imported from JSON schema'
      displayName: 'WebSession_Summarized_ThreatInfo_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'EventTime_t'
          type: 'dateTime'
        }
        {
          name: 'DestDomain_s'
          type: 'string'
        }
        {
          name: 'DstIpAddr_s'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'EventCount_d'
          type: 'string'
        }
        {
          name: 'EventResult_s'
          type: 'string'
        }
        {
          name: 'EventSeverity_s'
          type: 'string'
        }
        {
          name: 'SrcIpAddr_s'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'SrcUsername_s'
          type: 'string'
        }
        {
          name: 'ThreatCategory_s'
          type: 'string'
        }
        {
          name: 'ThreatField_s'
          type: 'string'
        }
        {
          name: 'ThreatName_s'
          type: 'string'
        }
        {
          name: 'ThreatOriginalConfidence_d'
          type: 'int'
        }
        {
          name: 'ThreatRiskLevel_d'
          type: 'int'
        }
        {
          name: 'SrcIpAddr_s'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'SrcIpAddr_s'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'SrcIpAddr_s'
          type: 'string'
          dataTypeHint: 3
        }
      ]
    }
  }
}

output tableName string = websessionsummarizedthreatinfoclTable.name
output tableId string = websessionsummarizedthreatinfoclTable.id
output provisioningState string = websessionsummarizedthreatinfoclTable.properties.provisioningState
