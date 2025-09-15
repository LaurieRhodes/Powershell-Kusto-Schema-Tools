// Bicep template for Log Analytics custom table: BitsightCompany_details_CL
// Generated on 2025-09-13 20:15:19 UTC
// Source: JSON schema export
// Original columns: 51, Deployed columns: 49 (only 'Type' filtered out)
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

resource bitsightcompanydetailsclTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'BitsightCompany_details_CL'
  properties: {
    plan: tablePlan
    retentionInDays: retentionInDays
    totalRetentionInDays: totalRetentionInDays
    schema: {
      name: 'BitsightCompany_details_CL'
      description: 'Custom table BitsightCompany_details_CL - imported from JSON schema'
      displayName: 'BitsightCompany_details_CL'
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
          name: 'PeopleCount'
          type: 'real'
        }
        {
          name: 'PermissionCanAnnotate'
          type: 'boolean'
        }
        {
          name: 'PermissionCanDownloadCompanyReport'
          type: 'boolean'
        }
        {
          name: 'PermissionCanEnableVendorAccess'
          type: 'boolean'
        }
        {
          name: 'PermissionCanViewCompanyReports'
          type: 'boolean'
        }
        {
          name: 'PermissionCanViewForensics'
          type: 'boolean'
        }
        {
          name: 'PermissionCanViewInfrastructure'
          type: 'boolean'
        }
        {
          name: 'PermissionCanViewIpAttributions'
          type: 'boolean'
        }
        {
          name: 'PermissionCanViewServiceProviders'
          type: 'boolean'
        }
        {
          name: 'Name'
          type: 'string'
        }
        {
          name: 'PermissionsHasControl'
          type: 'boolean'
        }
        {
          name: 'RatingIndustryMedian'
          type: 'string'
        }
        {
          name: 'Ratings'
          type: 'string'
        }
        {
          name: 'RelatedCompanies'
          type: 'string'
        }
        {
          name: 'SearchCount'
          type: 'real'
        }
        {
          name: 'ServiceProvider'
          type: 'boolean'
        }
        {
          name: 'Shortname'
          type: 'string'
        }
        {
          name: 'Sparkline'
          type: 'string'
        }
        {
          name: 'SubIndustry'
          type: 'string'
        }
        {
          name: 'SubIndustrySlug'
          type: 'string'
        }
        {
          name: 'PrimaryDomain'
          type: 'string'
        }
        {
          name: 'IsUnsampledAllowed'
          type: 'boolean'
        }
        {
          name: 'IsPrimary'
          type: 'boolean'
        }
        {
          name: 'IsMycompMysubsBundle'
          type: 'boolean'
        }
        {
          name: 'EventProduct'
          type: 'string'
        }
        {
          name: 'ComplianceClaimCertifications'
          type: 'string'
        }
        {
          name: 'ComplianceClaimTrustPage'
          type: 'string'
        }
        {
          name: 'PrimaryDomain'
          type: 'string'
        }
        {
          name: 'PrimaryCompanyName'
          type: 'string'
        }
        {
          name: 'AvailableUpgradeTypes'
          type: 'string'
        }
        {
          name: 'BulkEmailSenderStatus'
          type: 'string'
        }
        {
          name: 'CompanyFeatures'
          type: 'string'
        }
        {
          name: 'CustomerMonitoringCount'
          type: 'real'
        }
        {
          name: 'Description'
          type: 'string'
        }
        {
          name: 'DisplayURL'
          type: 'string'
          dataTypeHint: 0
        }
        {
          name: 'GUID'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: 'HasCompanyTree'
          type: 'boolean'
        }
        {
          name: 'HasPreferredContact'
          type: 'boolean'
        }
        {
          name: 'Hompage'
          type: 'string'
        }
        {
          name: 'InSpmPortfolio'
          type: 'boolean'
        }
        {
          name: 'Industry'
          type: 'string'
        }
        {
          name: 'IndustrySlug'
          type: 'string'
        }
        {
          name: 'Ipv4Count'
          type: 'real'
        }
        {
          name: 'IsBundle'
          type: 'boolean'
        }
        {
          name: 'IsCsp'
          type: 'boolean'
        }
        {
          name: 'SubscriptionType'
          type: 'string'
        }
        {
          name: 'SubscriptionTypeKey'
          type: 'string'
        }
      ]
    }
  }
}

output tableName string = bitsightcompanydetailsclTable.name
output tableId string = bitsightcompanydetailsclTable.id
output provisioningState string = bitsightcompanydetailsclTable.properties.provisioningState
