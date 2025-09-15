# log-analytics-to-adx-kql-export.ps1

## Overview

Exports Log Analytics table schemas as KQL scripts for Azure Data Explorer (ADX) with empirical data type corrections. Creates complete ADX table structures with ingestion mappings and update policies for seamless data migration.

## Purpose

- **ADX Migration**: Generate complete KQL scripts for recreating Log Analytics tables in ADX
- **Data Type Accuracy**: Apply empirical fixes for Microsoft API bugs before KQL generation
- **Ingestion Pipeline**: Create raw tables, mappings, and update policies for data flow
- **Flexible Export**: Support for all workspace tables or specific lists with filtering options

## Key Features

- ✅ **Microsoft API Bug Fixes**: TenantId→guid, Double→real, TimeGenerated→datetime
- ✅ **Complete ADX Pipeline**: Raw tables + main tables + update policies
- ✅ **Hybrid Discovery**: Management API + getschema for comprehensive column coverage
- ✅ **Consistent Filtering**: Configurable "underscore"" table/column filtering. Typically tables prefaced with underscores are only used by Microsoft although theses columns (normally __ResourceId) can be of benefit. Consider your needs when selecting to export tables with underscores or not.

## Configuration Settings

### Azure Configuration

```powershell
$workspaceName = 'myWorkspace'           # Log Analytics workspace name
$resourceGroupName = 'myResourceGroup'   # Azure resource group
$subscriptionId = '1111-2222-3333...'    # Azure subscription ID  
$tenantId = ''                           # Azure tenant (optional)
```

### Export Configuration

```powershell
$ExportAll = $false                      # Export all workspace tables  
$FilterUnderscoreTables = $true          # Filter out underscore tables/columns
```

### ADX Configuration

```powershell
$rawTableRetention = "1d"                # Raw table data retention
$rawTableCaching = "1h"                  # Raw table hot cache period
$mainTableCaching = "1d"                 # Main table hot cache period
```

### Discovery Settings

```powershell
$useHybridDiscovery = $true             # Use Management API + getschema
$preferManagementAPITypes = $true       # Prefer Management API types
```

### Specific Tables (when ExportAll = $false)

```powershell
$tablesToExport = @(
    'CommonSecurityLog',
    'SecurityEvent',
    'Syslog', 
    'WindowsEvent',
    # ... add more tables
)
```

## Configuration Combinations

| ExportAll | FilterUnderscoreTables | Result                                                |
| --------- | ---------------------- | ----------------------------------------------------- |
| `$false`  | `$true`                | Export specific tables, exclude underscore items      |
| `$false`  | `$false`               | Export specific tables, include underscore items      |
| `$true`   | `$true`                | Export all workspace tables, exclude underscore items |
| `$true`   | `$false`               | Export all workspace tables, include underscore items |

## Outputs

### KQL Script Files

**Location**: `kql\` directory  
**Format**: Complete ADX table creation scripts
**Naming**: `{TableName}.kql`

### KQL Script Structure

Each generated script contains:

#### 1. Raw Table Creation

```kusto
.create-merge table GCP_DNS_CLRaw (records:dynamic)
.alter-merge table GCP_DNS_CLRaw policy retention softdelete = 1d
.alter table GCP_DNS_CLRaw policy caching hot = 1h
```

#### 2. JSON Ingestion Mapping

```kusto
.create-or-alter table GCP_DNS_CLRaw ingestion json mapping 'GCP_DNS_CLRawMapping' 
'[{"column":"records","Properties":{"path":"$.records"}}]'
```

#### 3. Main Table Creation

```kusto
.create-merge table GCP_DNS_CL(
TimeGenerated:datetime,
TenantId:guid,
payload_vmInstanceId_d:real,
payload_serverLatency_d:real,
_TimeReceived:datetime
)
```

#### 4. Expansion Function

```kusto
.create-or-alter function GCP_DNS_CLExpand() {
GCP_DNS_CLRaw
| mv-expand events = records
| project
TimeGenerated = todatetime(events.TimeGenerated),
TenantId = toguid(events.TenantId),
payload_vmInstanceId_d = toreal(events.payload_vmInstanceId_d),
payload_serverLatency_d = toreal(events.payload_serverLatency_d),
_TimeReceived = todatetime(now())
}
```

#### 5. Update Policy

```kusto
.alter table GCP_DNS_CL policy update 
@'[{"Source": "GCP_DNS_CLRaw", "Query": "GCP_DNS_CLExpand()", "IsEnabled": "True", "IsTransactional": true}]'
```

### Console Output

- **Configuration Summary**: All settings and table counts
- **Processing Progress**: Real-time status for each table
- **Data Type Corrections**: Shows what Microsoft API bugs were fixed
- **Export Statistics**: Success/failure counts with discovery methods
- **Usage Instructions**: Next steps for ADX deployment

## Data Type Corrections Applied

### Microsoft API Bug Fixes

- **TenantId**: `string` → `guid` → `TenantId:guid` in ADX
- **WorkspaceId**: `string` → `guid` → `WorkspaceId:guid` in ADX  
- **TimeGenerated**: `string` → `datetime` → `TimeGenerated:datetime` in ADX
- **Double**: `double` → `real` → `ColumnName:real` in ADX

### ADX Type Mappings

| Log Analytics Type | ADX Type   | Conversion Function |
| ------------------ | ---------- | ------------------- |
| `string`           | `string`   | `tostring()`        |
| `datetime`         | `datetime` | `todatetime()`      |
| `guid`             | `guid`     | `toguid()`          |
| `real`             | `real`     | `toreal()`          |
| `int`              | `int`      | `toint()`           |
| `long`             | `long`     | `tolong()`          |
| `bool`             | `bool`     | `tobool()`          |
| `dynamic`          | `dynamic`  | `todynamic()`       |

## Prerequisites

### PowerShell Modules

```powershell
Install-Module Az.Accounts
Install-Module Az.OperationalInsights
```

### Required Files

- `LogAnalyticsCommon.psm1` (in same directory)

### Azure Permissions

- **Reader** access to Log Analytics workspace
- **Authenticated session**: `Connect-AzAccount`

### ADX Environment

- Azure Data Explorer cluster
- Database with appropriate permissions
- Ingestion permissions for data loading

## Usage Examples

### Export Specific Tables for ADX

```powershell
# Configure tables to export
$tablesToExport = @('CommonSecurityLog', 'SecurityEvent', 'GCP_DNS_CL')
$ExportAll = $false
$FilterUnderscoreTables = $true

# Run export
.\log-analytics-to-adx-kql-export.ps1
```

### Export All Workspace Tables

```powershell
# Configure for complete workspace export
$ExportAll = $true  
$FilterUnderscoreTables = $true

# Run export
.\log-analytics-to-adx-kql-export.ps1
```

### Include System Columns for Analysis

```powershell
# Include underscore columns like _ResourceId for enriched analysis
$ExportAll = $false
$FilterUnderscoreTables = $false

# Run export  
.\log-analytics-to-adx-kql-export.ps1
```

## ADX Deployment Workflow

### 1. Generate KQL Scripts

```powershell
.\log-analytics-to-adx-kql-export.ps1
```

### 2. Deploy to ADX

```kusto
// In ADX, run each generated .kql file
.execute database script <|
// Paste contents of TableName.kql here
```

### 3. Verify Table Structure

```kusto
// Check table schema
TableName | getschema

// Verify update policy
.show table TableName policy update
```

### 4. Test Data Ingestion

```kusto
// Ingest test data to raw table
.ingest into table TableNameRaw (@'{"records":[{"TimeGenerated":"2024-01-01T00:00:00Z","TenantId":"guid-here"}]}') 
with (format='json', jsonMappingReference='TableNameRawMapping')

// Verify data flows to main table
TableName | count
```

## Integration with Data Pipeline

### Source: Log Analytics

```
Log Analytics Workspace
        ↓
log-analytics-to-adx-kql-export.ps1
        ↓  
KQL Scripts (.kql files)
```

### Target: Azure Data Explorer

```
ADX Raw Tables (dynamic records)
        ↓ (JSON mapping)
ADX Main Tables (structured columns)  
        ↓ (update policy)
Queryable ADX Data
```

### Data Flow Architecture

```
JSON Data → Raw Table → Expansion Function → Main Table
     ↓           ↓              ↓              ↓
 Ingestion   Storage      Transformation   Analytics
```

## Troubleshooting

### Common Issues

- **Authentication**: Run `Connect-AzAccount` first
- **No tables found**: Verify workspace name and resource group
- **Type conversion errors**: Check for unsupported Log Analytics types
- **ADX deployment failures**: Verify ADX permissions and cluster connectivity

### Error Resolution

- **Token expired**: Re-authenticate with Azure
- **Schema mismatches**: Re-run export after Log Analytics schema changes  
- **Update policy failures**: Check expansion function syntax in ADX
- **Ingestion issues**: Verify JSON mapping configuration

## Advanced Configuration

### Custom Retention Policies

```powershell
$rawTableRetention = "7d"        # Longer raw data retention
$mainTableCaching = "3d"         # Extended hot cache for frequently accessed data
```

### Alternative JSON Mappings

The generated scripts include mapping options:

```kusto
// For nested records structure
'[{"column":"records","Properties":{"path":"$.records"}}]'

// For direct event structure  
'[{"column":"records","Properties":{"path":"$"}}]'
```

### Disable Hybrid Discovery

```powershell
$useHybridDiscovery = $false     # Management API only (faster, less comprehensive)
```

This script provides a complete migration path from Log Analytics to Azure Data Explorer with empirically corrected data types and production-ready ingestion pipelines.
