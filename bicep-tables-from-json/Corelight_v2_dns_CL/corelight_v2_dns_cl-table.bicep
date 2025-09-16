﻿// Bicep template for Log Analytics custom table: Corelight_v2_dns_CL
// Generated on 2025-09-17 06:39:59 UTC
// Source: JSON schema export
// Original columns: 28, Deployed columns: 28 (Type column filtered)
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

resource corelightv2dnsclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Corelight_v2_dns_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Corelight_v2_dns_CL'
      description: 'Custom table Corelight_v2_dns_CL - imported from JSON schema'
      displayName: 'Corelight_v2_dns_CL'
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
          name: 'answers_s'
          type: 'string'
        }
        {
          name: 'Z_d'
          type: 'real'
        }
        {
          name: 'RA_b'
          type: 'boolean'
        }
        {
          name: 'RD_b'
          type: 'boolean'
        }
        {
          name: 'TC_b'
          type: 'boolean'
        }
        {
          name: 'AA_b'
          type: 'boolean'
        }
        {
          name: 'rcode_name_s'
          type: 'string'
        }
        {
          name: 'rcode_d'
          type: 'real'
        }
        {
          name: 'qtype_name_s'
          type: 'string'
        }
        {
          name: 'qtype_d'
          type: 'real'
        }
        {
          name: 'qclass_name_s'
          type: 'string'
        }
        {
          name: 'TTLs_s'
          type: 'string'
        }
        {
          name: 'qclass_d'
          type: 'real'
        }
        {
          name: 'rtt_d'
          type: 'real'
        }
        {
          name: 'trans_id_d'
          type: 'real'
        }
        {
          name: 'proto_s'
          type: 'string'
        }
        {
          name: 'id_resp_p_d'
          type: 'real'
        }
        {
          name: 'id_resp_h_s'
          type: 'string'
        }
        {
          name: 'id_orig_p_d'
          type: 'real'
        }
        {
          name: 'id_orig_h_s'
          type: 'string'
        }
        {
          name: 'uid_s'
          type: 'string'
        }
        {
          name: 'ts_t'
          type: 'dateTime'
        }
        {
          name: '_write_ts_t'
          type: 'dateTime'
        }
        {
          name: '_system_name_s'
          type: 'string'
        }
        {
          name: 'query_s'
          type: 'string'
        }
        {
          name: 'rejected_b'
          type: 'boolean'
        }
      ]
    }
  }
}

output tableName string = corelightv2dnsclTable.name
output tableId string = corelightv2dnsclTable.id
output provisioningState string = corelightv2dnsclTable.properties.provisioningState
