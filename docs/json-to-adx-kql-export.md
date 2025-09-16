# JSON-to-ADX-kql-export.ps1

## Overview

Generates Azure Data Explorer (ADX) KQL scripts from JSON schema files with data type corrections.  Creates complete ADX table structure templates with ingestion mappings and update policies for seamless data migration from Log Analytics schemas.

Note that KQL script automation cannot be fully automated as the different methods used for obtaining raw event data will produce different data structures.  A data engineering requirement of ETL of raw data to destination table columns is still a requirement for every new table source integrated into Kusto systems.  

The example output .kql files take care of the heavy lifting for ensuring that destination tables and the ETL (referred to as Expand in the scripts) match.

Note that a '_TimeGenerated' is automatically appended to all created tables to allow for the tracking of when records are written to Kusto.  This is an important feature for continuous processing of new data when Kusto is integrated with automation.

## Purpose

- **JSON to ADX (Kusto) Schema Migration**: Converts JSON schemas to ADX table structures

## Key Features

- ✅ **JSON Schema Input**: Uses JSON schemas as source of truth
- ✅ **Schema Bug Fixes**: TenantId→guid, Double→real, TimeGenerated→datetime
- ✅ **Reserved Column Filtering**: Configurable filtering fof underscore prefaced table names for ADX compatibility

## Configuration Settings

### Input/Output Directories

```powershell
$jsonExportDirectory = Join-Path $PSScriptRoot "json-exports"     # Input JSON files
$outputDirectory = $PSScriptRoot                                  # Base output
$kqlDirectory = Join-Path $outputDirectory "kql-from-json"        # KQL output directory
```

### Kusto Configuration Settings

```powershell
$rawTableRetention = "1d"               # Raw table data retention
$rawTableCaching = "1h"                 # Raw table hot cache
$mainTableCaching = "1d"                # Main table hot cache
```

Initial Kusto settings are a guide for minimising cost with a typical SOC environment.

### Processing Settings

```powershell
$FilterUnderscoreTables = $true         # Filter underscore tables from processing
$FilterUnderscoreColumns = $true        # Filter underscore columns in output
$ErrorActionPreference = "Stop"        # Strict error handling
```

Most Log Analytics tables will contain some underscore preferenced columns that are typically (but not exclusively) used for internal Log Analytics automation.  There are potentially some advantages to replicating these columns in Kusto but probably little of consequence. 

## Input Requirements

### JSON Schema Format

**Source**: Output from `log-analytics-schema-export.ps1`
**Location**: `json-exports\` directory  
**Format**: JSON nested schema with corrected data types

**Expected Input Structure**:

```json
{
  "Name": "GCP_DNS_CL",
  "Properties": [
    {
      "Name": "TenantId",
      "Type": "Guid"
    },
    {
      "Name": "TimeGenerated", 
      "Type": "DateTime"
    },
    {
      "Name": "payload_vmInstanceId_d",
      "Type": "Double"
    },
    {
      "Name": "_ResourceId",
      "Type": "String"
    }
  ]
}
```

## Outputs

### KQL Script Files

**Location**: `kql-from-json\` directory
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

### JSON to ADX Mappings

| JSON Type  | ADX Type   | Conversion Function | Notes                                |
| ---------- | ---------- | ------------------- | ------------------------------------ |
| `String`   | `string`   | `tostring()`        | Standard text fields                 |
| `DateTime` | `datetime` | `todatetime()`      | ISO 8601 timestamps                  |
| `Guid`     | `guid`     | `toguid()`          | Fixed from Microsoft API string bug  |
| `Double`   | `real`     | `toreal()`          | Fixed from Microsoft API double→real |
| `Int`      | `int`      | `toint()`           | Integer values                       |
| `Long`     | `long`     | `tolong()`          | Large integers                       |
| `Boolean`  | `bool`     | `tobool()`          | True/false values                    |
| `Dynamic`  | `dynamic`  | `todynamic()`       | JSON objects/arrays                  |

### Pre-Applied Corrections

Since input comes from corrected JSON schemas:

- **TenantId**: Already corrected to `Guid` → generates `toguid()`
- **TimeGenerated**: Already corrected to `DateTime` → generates `todatetime()`  
- **Double columns**: Already corrected to `Double` → generates `toreal()`

## Column Filtering Options

Depending on your business use you will need to consider if the typically internal Microsoft columns for Log Analytics are retained or filtered away.  This can be set by switches in the script.  

### Underscore Table Filtering

```powershell
$FilterUnderscoreTables = $true         # Skip tables starting with _
```

**Filtered Tables**: `_Heartbeat`, `_Usage`, etc.

### Underscore Column Filtering

```powershell
$FilterUnderscoreColumns = $true        # Skip columns starting with _
```

**Filtered Columns**: `_TimeReceived`, `_BilledSize`, etc.
**Kept for ADX**: `_ResourceId` (useful for correlation)

### Filtering Combinations

| FilterTables | FilterColumns | Result                                  |
| ------------ | ------------- | --------------------------------------- |
| `$true`      | `$true`       | Process non-_ tables, exclude _ columns |
| `$true`      | `$false`      | Process non-_ tables, include _ columns |
| `$false`     | `$true`       | Process all tables, exclude _ columns   |
| `$false`     | `$false`      | Process all tables, include all columns |

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
