// Bicep template for Log Analytics custom table: ESETInspect_CL
// Generated on 2025-09-13 20:15:24 UTC
// Source: JSON schema export
// Original columns: 40, Deployed columns: 39 (only 'Type' filtered out)
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

resource esetinspectclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'ESETInspect_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'ESETInspect_CL'
      description: 'Custom table ESETInspect_CL - imported from JSON schema'
      displayName: 'ESETInspect_CL'
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
          name: 'moduleLgReputation_d'
          type: 'real'
        }
        {
          name: 'moduleName_s'
          type: 'string'
        }
        {
          name: 'moduleSha1_s'
          type: 'string'
        }
        {
          name: 'moduleSignatureType_s'
          type: 'string'
        }
        {
          name: 'moduleSigner_s'
          type: 'string'
        }
        {
          name: 'priority_d'
          type: 'real'
        }
        {
          name: 'processCommandLine_s'
          type: 'string'
        }
        {
          name: 'processId_d'
          type: 'real'
        }
        {
          name: 'processPath_s'
          type: 'string'
        }
        {
          name: 'processUser_s'
          type: 'string'
        }
        {
          name: 'resolved_b'
          type: 'boolean'
        }
        {
          name: 'ruleName_s'
          type: 'string'
        }
        {
          name: 'severityScore_d'
          type: 'real'
        }
        {
          name: 'threatName_s'
          type: 'string'
        }
        {
          name: 'threatUri_s'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'moduleLgPopularity_d'
          type: 'real'
        }
        {
          name: 'moduleLgAge_d'
          type: 'real'
        }
        {
          name: 'moduleLastExecutedLocally_t'
          type: 'string'
        }
        {
          name: 'moduleId_d'
          type: 'real'
        }
        {
          name: 'SourceSystem'
          type: 'string'
        }
        {
          name: 'Computer'
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
          name: 'RawData'
          type: 'string'
        }
        {
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: 'Severity'
          type: 'string'
        }
        {
          name: 'type_s'
          type: 'string'
        }
        {
          name: 'TableName'
          type: 'string'
        }
        {
          name: 'computerName_s'
          type: 'string'
        }
        {
          name: 'computerUuid_g'
          type: 'string'
        }
        {
          name: 'creationTime_t'
          type: 'dateTime'
        }
        {
          name: 'deepLink_s'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'handled_d'
          type: 'real'
        }
        {
          name: 'id_d'
          type: 'real'
        }
        {
          name: 'moduleFirstSeenLocally_t'
          type: 'string'
        }
        {
          name: 'computerId_d'
          type: 'real'
        }
        {
          name: 'uuid_g'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = esetinspectclTable.name
output tableId string = esetinspectclTable.id
output provisioningState string = esetinspectclTable.properties.provisioningState
