﻿// Bicep template for Log Analytics custom table: Corelight_v2_known_remotes_CL
// Generated on 2025-09-13 20:15:22 UTC
// Source: JSON schema export
// Original columns: 10, Deployed columns: 10 (only 'Type' filtered out)
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

resource corelightv2knownremotesclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_known_remotes_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_known_remotes_CL'
      description: 'Custom table Corelight_v2_known_remotes_CL - imported from JSON schema'
      displayName: 'Corelight_v2_known_remotes_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: '_path_s'
          type: 'string'
        }
        {
          name: '_system_name_s'
          type: 'string'
        }
        {
          name: '_write_ts_t'
          type: 'dateTime'
        }
        {
          name: 'ts_t'
          type: 'dateTime'
        }
        {
          name: 'duration_d'
          type: 'real'
        }
        {
          name: 'kuid_s'
          type: 'string'
        }
        {
          name: 'host_ip_s'
          type: 'string'
        }
        {
          name: 'num_conns_d'
          type: 'real'
        }
        {
          name: 'annotations_s'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = corelightv2knownremotesclTable.name
output tableId string = corelightv2knownremotesclTable.id
output provisioningState string = corelightv2knownremotesclTable.properties.provisioningState
