﻿// Bicep template for Log Analytics custom table: ZeroFox_CTI_phishing_CL
// Generated on 2025-09-17 06:40:08 UTC
// Source: JSON schema export
// Original columns: 10, Deployed columns: 10 (Type column filtered)
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

resource zerofoxctiphishingclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'ZeroFox_CTI_phishing_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'ZeroFox_CTI_phishing_CL'
      description: 'Custom table ZeroFox_CTI_phishing_CL - imported from JSON schema'
      displayName: 'ZeroFox_CTI_phishing_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'scanned_t'
          type: 'dateTime'
        }
        {
          name: 'domain_s'
          type: 'string'
        }
        {
          name: 'url_s'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'cert_authority_s'
          type: 'string'
        }
        {
          name: 'cert_fingerprint_s'
          type: 'string'
        }
        {
          name: 'cert_issued_s'
          type: 'string'
        }
        {
          name: 'host_ip_s'
          type: 'string'
        }
        {
          name: 'host_asn_d'
          type: 'real'
        }
        {
          name: 'host_geo_s'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = zerofoxctiphishingclTable.name
output tableId string = zerofoxctiphishingclTable.id
output provisioningState string = zerofoxctiphishingclTable.properties.provisioningState
