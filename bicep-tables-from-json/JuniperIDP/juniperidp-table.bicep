// Bicep template for Log Analytics custom table: JuniperIDP
// Generated on 2025-09-17 06:40:04 UTC
// Source: JSON schema export
// Original columns: 41, Deployed columns: 41 (Type column filtered)
// Underscore columns included
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

resource juniperidpTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'JuniperIDP'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'JuniperIDP'
      description: 'Custom table JuniperIDP - imported from JSON schema'
      displayName: 'JuniperIDP'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'EventVendor'
          type: 'string'
        }
        {
          name: 'SrcNatIpAddr'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'SrcNatPortNumber'
          type: 'string'
        }
        {
          name: 'DstNatIpAddr'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'DstNatPortNumber'
          type: 'string'
        }
        {
          name: 'NetworkDuration'
          type: 'string'
        }
        {
          name: 'DstBytes'
          type: 'string'
        }
        {
          name: 'SrcBytes'
          type: 'string'
        }
        {
          name: 'ThreatName'
          type: 'string'
        }
        {
          name: 'DstPackets'
          type: 'string'
        }
        {
          name: 'SrcZone'
          type: 'string'
        }
        {
          name: 'SrcIntefaceName'
          type: 'string'
        }
        {
          name: 'DstZone'
          type: 'string'
        }
        {
          name: 'DstInterfaceName'
          type: 'string'
        }
        {
          name: 'PacketLogId'
          type: 'string'
        }
        {
          name: 'IsAlert'
          type: 'string'
        }
        {
          name: 'DstUserName'
          type: 'string'
        }
        {
          name: 'SrcPackets'
          type: 'string'
        }
        {
          name: 'EventSeverity'
          type: 'string'
        }
        {
          name: 'DvcAction'
          type: 'string'
        }
        {
          name: 'RepeatCount'
          type: 'string'
        }
        {
          name: 'EventProduct'
          type: 'string'
        }
        {
          name: 'DvcHostname'
          type: 'string'
        }
        {
          name: 'SrcDvcType'
          type: 'string'
        }
        {
          name: 'EventType'
          type: 'string'
        }
        {
          name: 'SrcDvcOs'
          type: 'string'
        }
        {
          name: 'EventEndTime'
          type: 'string'
        }
        {
          name: 'MessageType'
          type: 'string'
        }
        {
          name: 'SrcIpAddr'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'DstIpAddr'
          type: 'string'
          dataTypeHint: 3
        }
        {
          name: 'DstPortNumber'
          type: 'string'
        }
        {
          name: 'NetworkProtocol'
          type: 'string'
        }
        {
          name: 'ServiceName'
          type: 'string'
        }
        {
          name: 'NetworkApplicationProtocol'
          type: 'string'
        }
        {
          name: 'NetworkRuleNumber'
          type: 'string'
        }
        {
          name: 'NetworkRulebaseName'
          type: 'string'
        }
        {
          name: 'PolicyName'
          type: 'string'
        }
        {
          name: 'ExportId'
          type: 'string'
        }
        {
          name: 'Roles'
          type: 'string'
        }
        {
          name: 'EventMessage'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = juniperidpTable.name
output tableId string = juniperidpTable.id
output provisioningState string = juniperidpTable.properties.provisioningState
