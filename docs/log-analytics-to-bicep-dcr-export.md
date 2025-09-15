# log-analytics-to-bicep-dcr-export.ps1

## Overview
Exports Log Analytics table schemas as Bicep Data Collection Rule (DCR) templates with complete deployment packages. Uses hybrid schema discovery and generates production-ready DCR templates with correct output stream mappings, role assignments, and parameterized deployment scripts.

## Purpose
- **DCR Template Generation**: Create complete Bicep DCR deployment packages
- **Schema-Driven DCRs**: Use Log Analytics schemas to generate accurate DCR definitions
- **Output Stream Logic**: Automatically determine correct output streams based on table types
- **Production Deployment**: Generate parameterized templates with deployment automation

## Key Features
- ✅ **Hybrid Schema Discovery**: Combines Management API + getschema for complete coverage
- ✅ **Correct Output Streams**: Automatic Microsoft- vs Custom- stream determination
- ✅ **JSON-Compatible Input**: Uses string/dynamic types with KQL transform layer
- ✅ **Complete Deployment Package**: Bicep templates, parameters, and PowerShell scripts
- ✅ **Role Assignment Integration**: Includes RBAC for service principal access
- ✅ **Empirical Corrections**: Built-in fixes for Microsoft API bugs

## Configuration Settings

### Azure Environment
```powershell
# UPDATE THESE VALUES FOR YOUR ENVIRONMENT
$workspaceName = 'YOUR-WORKSPACE-NAME'
$resourceGroupName = 'YOUR-RESOURCE-GROUP-NAME'
$subscriptionId = 'YOUR-SUBSCRIPTION-ID'
$tenantId = ''  # Optional - leave empty to use current context
```

**Example Configuration**:
```powershell
$workspaceName = 'SentinelAUE'
$resourceGroupName = 'sentinel'
$subscriptionId = '2be53ae5-6e46-47df-beb9-6f3a795387b8'
```

### Table Selection
```powershell
$tablesToExport = @(
    'Anomalies',
    'CommonSecurityLog',
    'SecurityEvent',
    'Syslog',
    'WindowsEvent',
    'OktaV2_CL'
)
```

### Output Configuration
```powershell
$outputDirectory = $PSScriptRoot
$dcrDirectory = Join-Path $outputDirectory "dcr"
```

### Bicep Template Configuration
```powershell
$bicepConfig = @{
    DefaultLocation = "Australia East"
    DefaultWorkspaceName = "sentinel-workspace"
    RoleDefinitionId = "3913510d-42f4-4e42-8a64-420c390055eb" # Monitoring Metrics Publisher
}
```

### Discovery Settings
```powershell
$useHybridDiscovery = $true        # Use both Management API + getschema
$preferManagementAPITypes = $true  # Prefer Management API types over getschema
```

## DCR Design Principles

### JSON-Compatible Input Schema
DCRs receiving JSON data can only handle limited input types:
- **string**: Text data, dates, GUIDs (converted in transform)
- **dynamic**: JSON objects and arrays
- **int**: Integers (rarely used due to string conversion safety)

**All other types** (datetime, guid, real, bool) are received as strings and converted via KQL transform for maximum resilience against data format variations.

### Transform Layer Logic
```kusto
source | project 
    TimeGenerated = todatetime(TimeGenerated),
    TenantId = toguid(TenantId),
    EventID = toint(EventID),
    payload_count_d = toreal(payload_count_d)
```

This approach provides:
- **Operator Error Protection**: Handles "123" vs 123 variations
- **Type Safety**: Explicit conversions with error handling
- **Data Validation**: Invalid data converts to null rather than failing ingestion

## Output Stream Determination

### Automatic Stream Selection
The script uses Management API table type to determine correct output streams:

| Table Type | Table Name Pattern | Output Stream | Notes |
|------------|-------------------|---------------|-------|
| `CustomLog` | `*_CL` | `Custom-TableName` | All custom logs |
| `Microsoft` | Known writable | `Microsoft-TableName` | Specific Microsoft tables |
| `Microsoft` | Other | `Custom-TableName` | New data to existing tables |
| `SearchResults` | Any | `Custom-TableName` | Search result tables |

### Known Writable Microsoft Tables
```powershell
$writableMicrosoftTables = @(
    'CommonSecurityLog',
    'Syslog', 
    'SecurityEvent',
    'WindowsEvent'
)
```

These tables can accept new data via `Microsoft-` prefixed streams.

### Custom Tables  
All custom tables (ending with `_CL`) automatically use `Custom-` prefixed output streams.

## Generated Templates

### Bicep DCR Template Structure
Each table generates a complete Bicep template with:

#### Parameters
```bicep
@description('The location of the resources')
param location string = 'Australia East'

@description('The name of the Data Collection Endpoint Id')
param dataCollectionEndpointId string

@description('The Log Analytics Workspace Id used for Sentinel')
param workspaceResourceId string

@description('The Target Sentinel workspace name')
param workspaceName string = 'sentinel-workspace'

@description('The Service Principal Object ID of the Entra App')
param servicePrincipalObjectId string
```

#### Stream Declarations
```bicep
streamDeclarations: {
  'Custom-TableName': {
    columns: [
      {
        name: 'TimeGenerated'
        type: 'string'
      }
      {
        name: 'TenantId'
        type: 'string'
      }
      {
        name: 'EventData'
        type: 'dynamic'
      }
    ]
  }
}
```

#### Data Flow with Transform
```bicep
dataFlows: [
  {
    streams: ['Custom-TableName']
    destinations: ['Sentinel-TableName']
    transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), EventData = todynamic(EventData)'
    outputStream: 'Custom-TableName'
  }
]
```

#### Role Assignment
```bicep
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: dataCollectionRule
  name: guid(resourceGroup().id, roleDefinitionResourceId, dataCollectionRule.name)
  properties: {
    roleDefinitionId: roleDefinitionResourceId
    principalId: servicePrincipalObjectId
    principalType: 'ServicePrincipal'
  }
}
```

## Output Structure

### Per-Table Deployment Package
Each table creates a complete deployment directory:

```
dcr\
└── TableName\
    ├── dcr-TableName.bicep           # Main Bicep template
    ├── dcr-TableName.parameters.json # Parameters file with placeholders
    └── deploy-TableName.ps1          # PowerShell deployment script
```

### Parameters File Example
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": { "value": "Australia East" },
    "dataCollectionEndpointId": { "value": "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Insights/dataCollectionEndpoints/{dce-name}" },
    "workspaceResourceId": { "value": "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.OperationalInsights/workspaces/{workspace-name}" },
    "workspaceName": { "value": "sentinel-workspace" },
    "servicePrincipalObjectId": { "value": "{service-principal-object-id}" }
  }
}
```

### Deployment Script Example
```powershell
# Deploy TableName Data Collection Rule
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-TableName.parameters.json"
)

$deploymentName = "dcr-TableName-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying TableName Data Collection Rule..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-TableName.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
```

## Schema Discovery Process

### Hybrid Discovery Workflow
```
1. Management API Call
   ├── Get table schema
   ├── Get table type (CustomLog, Microsoft, etc.)
   └── Extract column definitions

2. getschema Query (if enabled)
   ├── Query: TableName | getschema  
   ├── Discover additional columns
   └── Apply type corrections

3. Merge Results
   ├── Combine both sources
   ├── Prefer Management API types
   └── Report additional columns found
```

### Column Processing
```
1. Filter underscore columns (exclude system columns)
2. Apply Microsoft API bug fixes:
   ├── TenantId: string → guid
   ├── WorkspaceId: string → guid
   └── Double → real (ADX standard)
3. Sort columns (TimeGenerated first, Type last)
4. Convert to DCR input types (mostly strings)
5. Generate transform functions
```

## Usage Examples

### Basic DCR Export
```powershell
# 1. Configure Azure environment in script
# 2. Authenticate to Azure
Connect-AzAccount

# 3. Run export
.\log-analytics-to-bicep-dcr-export.ps1
```

### Deploy Generated DCRs
```powershell
# Navigate to table directory
cd dcr\CommonSecurityLog

# Update parameters file with actual values
# Edit dcr-CommonSecurityLog.parameters.json

# Deploy DCR
.\deploy-CommonSecurityLog.ps1 -ResourceGroupName "my-rg"
```

### Bulk Deployment
```powershell
# Deploy all generated DCRs
Get-ChildItem dcr\* -Directory | ForEach-Object {
    $tableName = $_.Name
    Set-Location $_.FullName
    
    # Update parameters file first, then deploy
    .\deploy-$tableName.ps1 -ResourceGroupName "my-resource-group"
}
```

## Prerequisites

### Azure Environment
- **Log Analytics workspace**: Source of schema information
- **Data Collection Endpoint**: Target for DCR deployment
- **Service Principal**: For DCR access permissions
- **Azure PowerShell**: `Az.Accounts`, `Az.OperationalInsights` modules

### Permissions Required
- **Log Analytics**: Reader access to workspace
- **Resource Group**: Contributor access for DCR deployment
- **Subscription**: Reader access for resource ID construction

### Dependencies
- **Module**: `LogAnalyticsCommon.psm1` in same directory
- **Authentication**: Valid Azure authentication context

## Console Output

### Processing Status
```
Log Analytics to Bicep DCR Export Script
========================================

Configuration:
  Workspace: SentinelAUE
  Resource Group: sentinel
  Subscription: 2be53ae5-6e46-47df-beb9-6f3a795387b8
  Tables to Export: 6 tables
  Output Directory: dcr
  Hybrid Discovery: True

Testing prerequisites and authentication...
SUCCESS: Authenticated as user@company.com

Acquiring access tokens...
SUCCESS: Management API token acquired
SUCCESS: Log Analytics API token acquired
SUCCESS: Workspace GUID: 12345678-1234-1234-1234-123456789abc

Tables to Export:
  * CommonSecurityLog
  * SecurityEvent
  * Syslog
  * WindowsEvent
  * OktaV2_CL

Generating DCR files...
Processing: CommonSecurityLog
    Generating DCR schema (JSON input types only)...
      TenantId: string -> guid (via TenantId = toguid(TenantId))
      EventTime: string -> datetime (via EventTime = todatetime(EventTime))
    Output stream: Microsoft-CommonSecurityLog
  SUCCESS: 42 columns (37 mgmt, 5 additional) -> DCR files

Processing: SecurityEvent
    Output stream: Microsoft-SecurityEvent
  SUCCESS: 45 columns (45 mgmt, 0 additional) -> DCR files

Processing: OktaV2_CL
    Output stream: Custom-OktaV2_CL
  SUCCESS: 23 columns (23 mgmt, 0 additional) -> DCR files

Export Summary:
===============
SUCCESS: 5/5 tables exported
FAILED: 0/5 tables failed

Successful Exports:
  * CommonSecurityLog: 42 columns (Microsoft)
  * SecurityEvent: 45 columns (Microsoft)
  * Syslog: 38 columns (Microsoft)
  * WindowsEvent: 12 columns (Microsoft)
  * OktaV2_CL: 23 columns (CustomLog)

DCR files created in dcr\ directory with complete deployment packages.
Update parameters files and run deployment scripts as needed.
```

## Advanced Configuration

### Custom Output Stream Logic
Modify `Get-DCROutputStreamName` function for custom stream determination:

```powershell
# In LogAnalyticsCommon.psm1
function Get-DCROutputStreamName {
    param([string]$tableName, [string]$tableType)
    
    # Custom logic for your environment
    if ($tableName -like "*MyCompany*") {
        return "Custom-$tableName"
    }
    
    # Default logic...
}
```

### Extended Writable Microsoft Tables
Add more Microsoft tables that support direct ingestion:

```powershell
$writableMicrosoftTables = @(
    'CommonSecurityLog',
    'Syslog',
    'SecurityEvent', 
    'WindowsEvent',
    'YourCustomMicrosoftTable'  # Add your known writable tables
)
```

### Custom Bicep Configuration
```powershell
$bicepConfig = @{
    DefaultLocation = "West Europe"           # Your preferred region
    DefaultWorkspaceName = "production-ws"   # Your workspace naming
    RoleDefinitionId = "3913510d-42f4-4e42-8a64-420c390055eb"  # Keep this value
}
```

## Troubleshooting

### Common Issues

**"Configuration values cannot be empty"**
- Update workspace name, resource group, and subscription ID
- Ensure all placeholder values are replaced

**Authentication failures**
- Run `Connect-AzAccount` and verify permissions
- Check Log Analytics workspace access permissions

**"No columns found"**
- Verify table exists and is accessible
- Check if table is empty or has restricted access

**DCR deployment failures**
- Verify Data Collection Endpoint exists
- Check service principal permissions
- Validate workspace resource ID format

### DCR-Specific Issues

**Invalid output stream errors**
- Check table type detection logic
- Verify stream naming conventions
- Review Microsoft vs Custom stream requirements

**Transform KQL errors**
- Validate type conversion functions
- Check for unsupported column types
- Review KQL syntax in generated templates

**Role assignment failures**
- Verify service principal object ID
- Check subscription-level permissions
- Validate role definition ID

## Integration Workflows

### Complete Log Analytics → DCR Pipeline
```
1. log-analytics-to-bicep-dcr-export.ps1  →  Generate DCR templates
2. Update parameters files                →  Configure environment-specific values  
3. Deploy DCRs                           →  Create data collection infrastructure
4. Configure data sources                →  Point applications to DCR endpoints
```

### Schema-Driven DCR Development
```
1. log-analytics-to-json-export.ps1       →  Export schemas to JSON
2. Modify JSON files                      →  Customize column definitions
3. json-to-bicep-dcr-export.ps1          →  Generate DCRs from modified schemas
4. Deploy customized DCRs                 →  Production deployment
```

This script provides enterprise-ready DCR template generation with comprehensive deployment automation, ensuring reliable data collection infrastructure that follows Microsoft best practices for schema management and stream configuration.
