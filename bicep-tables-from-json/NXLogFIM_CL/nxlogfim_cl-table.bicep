// Bicep template for Log Analytics custom table: NXLogFIM_CL
// Generated on 2025-09-17 06:40:05 UTC
// Source: JSON schema export
// Original columns: 27, Deployed columns: 26 (Type column filtered)
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

resource nxlogfimclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'NXLogFIM_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'NXLogFIM_CL'
      description: 'Custom table NXLogFIM_CL - imported from JSON schema'
      displayName: 'NXLogFIM_CL'
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
          name: '_IsBillable'
          type: 'string'
        }
        {
          name: '_BilledSize'
          type: 'real'
        }
        {
          name: 'SourceModuleType_s'
          type: 'string'
        }
        {
          name: 'SourceModuleName_s'
          type: 'string'
        }
        {
          name: 'Severity_s'
          type: 'string'
        }
        {
          name: 'SeverityValue_d'
          type: 'real'
        }
        {
          name: 'RawData'
          type: 'string'
        }
        {
          name: 'PrevModificationTime_t'
          type: 'dateTime'
        }
        {
          name: 'PrevFileSize_d'
          type: 'real'
        }
        {
          name: 'PrevFileName_s'
          type: 'string'
        }
        {
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: 'PrevDigest_s'
          type: 'string'
        }
        {
          name: 'ModificationTime_t'
          type: 'dateTime'
        }
        {
          name: 'Hostname_s'
          type: 'string'
        }
        {
          name: 'HostIP_s'
          type: 'string'
        }
        {
          name: 'FileSize_d'
          type: 'real'
        }
        {
          name: 'FileName_s'
          type: 'string'
        }
        {
          name: 'EventType_s'
          type: 'string'
        }
        {
          name: 'EventTime_t'
          type: 'dateTime'
        }
        {
          name: 'EventReceivedTime_t'
          type: 'dateTime'
        }
        {
          name: 'Digest_s'
          type: 'string'
        }
        {
          name: 'DigestName_s'
          type: 'string'
        }
        {
          name: 'Object_s'
          type: 'string'
        }
        {
          name: '_SubscriptionId'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = nxlogfimclTable.name
output tableId string = nxlogfimclTable.id
output provisioningState string = nxlogfimclTable.properties.provisioningState
