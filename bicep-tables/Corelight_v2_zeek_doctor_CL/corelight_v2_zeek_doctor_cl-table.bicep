﻿// Bicep template for Log Analytics custom table: Corelight_v2_zeek_doctor_CL
// Generated on 2025-09-13 20:15:23 UTC
// Source: JSON schema export
// Original columns: 12, Deployed columns: 12 (only 'Type' filtered out)
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

resource corelightv2zeekdoctorclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_zeek_doctor_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_zeek_doctor_CL'
      description: 'Custom table Corelight_v2_zeek_doctor_CL - imported from JSON schema'
      displayName: 'Corelight_v2_zeek_doctor_CL'
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
          name: 'node_s'
          type: 'string'
        }
        {
          name: 'check_s'
          type: 'string'
        }
        {
          name: 'total_d'
          type: 'real'
        }
        {
          name: 'hits_d'
          type: 'real'
        }
        {
          name: 'total_delta_d'
          type: 'real'
        }
        {
          name: 'hits_delta_d'
          type: 'real'
        }
        {
          name: 'percent_d'
          type: 'real'
        }
      ]
    }
  }
}

output tableName string = corelightv2zeekdoctorclTable.name
output tableId string = corelightv2zeekdoctorclTable.id
output provisioningState string = corelightv2zeekdoctorclTable.properties.provisioningState
