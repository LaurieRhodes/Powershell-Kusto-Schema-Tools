﻿// Bicep template for Log Analytics custom table: Tomcat_CL
// Generated on 2025-09-17 06:40:07 UTC
// Source: JSON schema export
// Original columns: 6, Deployed columns: 5 (Type column filtered)
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

resource tomcatclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'Tomcat_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'Tomcat_CL'
      description: 'Custom table Tomcat_CL - imported from JSON schema'
      displayName: 'Tomcat_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
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
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: '_SubscriptionId'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = tomcatclTable.name
output tableId string = tomcatclTable.id
output provisioningState string = tomcatclTable.properties.provisioningState
