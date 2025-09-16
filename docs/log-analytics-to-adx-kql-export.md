# Log-Analytics-to-ADX-kql-export.ps1

## Overview

Exports Log Analytics table schemas as KQL scripts for Azure Data Explorer (ADX) with data type corrections. Creates complete ADX table structures with ingestion mappings and update policies for seamless data migration.

## Purpose

- **ADX Migration**: Generate complete KQL scripts for recreating Log Analytics tables in ADX

## Key Features

- ✅ **Microsoft API Bug Fixes**: TenantId→guid, Double→real, TimeGenerated→datetime
- ✅ **Hybrid Discovery**: Management API + getschema for comprehensive column coverage
- ✅ **Optional Filtering**: Configurable "underscore"" table/column filtering. Typically tables prefaced with underscores are only used by Microsoft although theses columns (normally __ResourceId) can be of benefit. Consider your needs when selecting to export tables with underscores or not.

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

**Location**: `kql-from-log-analytics\` directory  
**Format**: Complete ADX table creation scripts
**Naming**: `{TableName}.kql`

### KQL Script Structure

Each generated script contains a standard template for creating that table in Kusto / ADX:

#### 1. Raw Table Creation

```kusto
.create-merge table GCP_DNS_CLRaw (records:dynamic)
.alter-merge table GCP_DNS_CLRaw policy retention softdelete = 1d
.alter table GCP_DNS_CLRaw policy caching hot = 1h
```

Every table has a "Raw" injection table for receiving dynamic, unstructure records.  These records will be transformed almost instantly by your ETL / Expand function into a fully structured data format.  Retention of these records is only for troubleshooting purposes.  

#### 2. JSON Ingestion Mapping

```kusto
.create-or-alter table GCP_DNS_CLRaw ingestion json mapping 'GCP_DNS_CLRawMapping' 
'[{"column":"records","Properties":{"path":"$.records"}}]'
// Alternative for direct events: '[{"column":"records","Properties":{"path":"$"}}]'
```

For standardisation, a mapping file is created for all Raw tables.  The Mapping is used when creating a [Data Connection](https://learn.microsoft.com/en-us/azure/data-explorer/create-event-hubs-connection?tabs=get-data%2Cget-data-2) from Kusto to an Event Hub.  It instructs the data pipeline to target incoming data to the records column of the raw table.

Two typical patterns are normally seen with incoming data.  Microsoft systems typically export data in a nested format under a records array.  Other systems tend to submit event records un-nested.  Both patterns are shown in the template.

#### 3. Expansion Function

```kusto
.create-or-alter function GCP_DNS_CLExpand() {
GCP_DNS_CLRaw
| mv-expand events = records
// Alternative for non-nested: | extend events = records
| project
TimeGenerated = todatetime(events.TimeGenerated),
TenantId = toguid(events.TenantId),
payload_vmInstanceId_d = toreal(events.payload_vmInstanceId_d),
payload_serverLatency_d = toreal(events.payload_serverLatency_d),
_TimeReceived = todatetime(now())
}
```

The Expansion function is the ETL process for mapping incoming log events to the currect destination table.

**Important** Depending on the original log source producing nested arrays of events or non-nested sequences of events the ETL may need to mv-expand data for each record to be represented as an individual row of data.  Both patterns are included in the template

Data exported directly from Log Analytics tends to have a straightforward 1-to-1 correlation of events.<field> to the intended destination field names.  Directly ingested data for other source systems will require some experimentation and often some KQL work to get data to align as expected.

#### 4. Update Policy

```kusto
.alter table GCP_DNS_CL policy update 
@'[{"Source": "GCP_DNS_CLRaw", "Query": "GCP_DNS_CLExpand()", "IsEnabled": "True", "IsTransactional": true}]'
```

Once an Expand function is doing ETL properly, a table update policy based on events arriving in the Raw table is enabled.  This ensures that each record is automatically transformed in realtime.

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

### Required Files

- **Input**: JSON schema files in `json-exports\` directory
- **Module**: `LogAnalyticsCommon.psm1` in same directory

## Usage Examples

### Deploy to ADX

```powershell
# In ADX Web UI or Kusto Explorer
.execute database script <|
// Paste contents of generated .kql file
```
