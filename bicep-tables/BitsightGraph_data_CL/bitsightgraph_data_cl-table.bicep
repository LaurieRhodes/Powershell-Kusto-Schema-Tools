﻿// Bicep template for Log Analytics custom table: BitsightGraph_data_CL
// Generated on 2025-09-13 20:15:20 UTC
// Source: JSON schema export
// Original columns: 9, Deployed columns: 8 (only 'Type' filtered out)
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

resource bitsightgraphdataclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'BitsightGraph_data_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'BitsightGraph_data_CL'
      description: 'Custom table BitsightGraph_data_CL - imported from JSON schema'
      displayName: 'BitsightGraph_data_CL'
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
          name: 'EventProduct'
          type: 'string'
        }
        {
          name: 'RatingDate'
          type: 'string'
        }
        {
          name: 'Rating'
          type: 'real'
        }
        {
          name: 'CompanyName'
          type: 'string'
        }
        {
          name: 'RatingDifferance'
          type: 'real'
        }
        {
          name: 'percentage'
          type: 'real'
        }
      ]
    }
  }
}

output tableName string = bitsightgraphdataclTable.name
output tableId string = bitsightgraphdataclTable.id
output provisioningState string = bitsightgraphdataclTable.properties.provisioningState
