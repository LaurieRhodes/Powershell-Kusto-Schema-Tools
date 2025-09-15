# json-to-adx-kql-export.ps1

## Overview
Generates Azure Data Explorer (ADX) KQL scripts from JSON schema files with empirical data type corrections. Creates complete ADX table structures with ingestion mappings and update policies for seamless data migration from Log Analytics schemas.

## Purpose
- **JSON to ADX Migration**: Convert corrected JSON schemas to ADX table structures
- **Data Type Accuracy**: Apply empirical fixes before ADX KQL generation
- **Complete ADX Pipeline**: Generate raw tables, mappings, functions, and update policies
- **Schema Consistency**: Use pre-corrected JSON schemas from other toolkit scripts

## Key Features
- ✅ **JSON Schema Input**: Uses corrected JSON schemas as source of truth
- ✅ **Microsoft API Bug Fixes**: TenantId→guid, Double→real, TimeGenerated→datetime
- ✅ **Complete ADX Pipeline**: Raw tables + main tables + update policies
- ✅ **Reserved Column Filtering**: Configurable filtering for ADX compatibility
- ✅ **Ingestion Mappings**: JSON mapping configurations for data flow

## Configuration Settings

### Input/Output Directories
```powershell
$jsonExportDirectory = Join-Path $PSScriptRoot "json-exports"     # Input JSON files
$outputDirectory = $PSScriptRoot                                  # Base output
$kqlDirectory = Join-Path $outputDirectory "kql-from-json"        # KQL output directory
```

### ADX Configuration
```powershell
$rawTableRetention = "1d"               # Raw table data retention
$rawTableCaching = "1h"                 # Raw table hot cache
$mainTableCaching = "1d"                # Main table hot cache
```

### Processing Settings  
```powershell
$FilterUnderscoreTables = $true         # Filter underscore tables from processing
$FilterUnderscoreColumns = $true        # Filter underscore columns in output
$ErrorActionPreference = "Stop"        # Strict error handling
```

## Input Requirements

### JSON Schema Format
**Source**: Output from `log-analytics-schema-export.ps1`
**Location**: `json-exports\` directory  
**Format**: Microsoft-compatible nested schema with corrected data types

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
// Alternative for direct events: '[{"column":"records","Properties":{"path":"$"}}]'
```

#### 3. Main Table Creation (Corrected Types)
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

## Data Type Corrections Applied

### Empirical JSON to ADX Mappings
| JSON Type | ADX Type | Conversion Function | Notes |
|-----------|----------|-------------------|-------|
| `String` | `string` | `tostring()` | Standard text fields |
| `DateTime` | `datetime` | `todatetime()` | ISO 8601 timestamps |
| `Guid` | `guid` | `toguid()` | Fixed from Microsoft API string bug |
| `Double` | `real` | `toreal()` | Fixed from Microsoft API double→real |
| `Int` | `int` | `toint()` | Integer values |
| `Long` | `long` | `tolong()` | Large integers |
| `Boolean` | `bool` | `tobool()` | True/false values |
| `Dynamic` | `dynamic` | `todynamic()` | JSON objects/arrays |

### Pre-Applied Corrections
Since input comes from corrected JSON schemas:
- **TenantId**: Already corrected to `Guid` → generates `toguid()`
- **TimeGenerated**: Already corrected to `DateTime` → generates `todatetime()`  
- **Double columns**: Already corrected to `Double` → generates `toreal()`

## Column Filtering Options

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

| FilterTables | FilterColumns | Result |
|-------------|---------------|--------|
| `$true` | `$true` | Process non-_ tables, exclude _ columns |
| `$true` | `$false` | Process non-_ tables, include _ columns |  
| `$false` | `$true` | Process all tables, exclude _ columns |
| `$false` | `$false` | Process all tables, include all columns |

## Prerequisites

### Required Files
- **Input**: JSON schema files in `json-exports\` directory
- **Module**: `LogAnalyticsCommon.psm1` in same directory

### JSON Schema Source
Generate input files first:
```powershell
# Primary schema export
.\log-analytics-schema-export.ps1

# Optional additional cleanup
.\json-schema-cleanup.ps1
```

### ADX Environment
- Azure Data Explorer cluster
- Database with appropriate permissions
- Ingestion permissions for data loading

## Usage Examples

### Generate ADX Scripts for All JSON Files
```powershell
# Ensure JSON schemas exist
.\log-analytics-schema-export.ps1

# Generate ADX KQL scripts
.\json-to-adx-kql-export.ps1
```

### Generate with Custom Filtering
```powershell
# Edit script configuration
$FilterUnderscoreTables = $false        # Include system tables
$FilterUnderscoreColumns = $false       # Include all columns for analysis

# Run generation
.\json-to-adx-kql-export.ps1
```

### Deploy to ADX
```powershell
# In ADX Web UI or Kusto Explorer
.execute database script <|
// Paste contents of generated .kql file
```

## ADX Data Flow Architecture

### Ingestion Pipeline
```
JSON Data → Raw Table → Expansion Function → Main Table
     ↓           ↓              ↓              ↓
 Ingestion   Storage      Transformation   Analytics
```

### Table Structure
```
GCP_DNS_CLRaw (records:dynamic)     # Raw JSON storage
      ↓ (update policy)
GCP_DNS_CL (structured columns)     # Queryable table with correct types
```

### Mapping Options
Scripts include both mapping variations:
```kusto
// For nested structure: {"records":[{...}]}
'[{"column":"records","Properties":{"path":"$.records"}}]'

// For direct array: [{...},{...}]
'[{"column":"records","Properties":{"path":"$"}}]'
```

## Integration Workflow

### Complete JSON to ADX Process
```
1. log-analytics-schema-export.ps1     →  JSON schemas
2. json-schema-cleanup.ps1 (optional)  →  Additional cleanup
3. json-to-adx-kql-export.ps1          →  ADX KQL scripts
4. Deploy to ADX                       →  Production tables
```

### Comparison with Direct LA Export
```
Direct LA Export:     log-analytics-to-adx-kql-export.ps1
JSON-Based Export:    json-to-adx-kql-export.ps1

Advantages of JSON-based:
✅ Uses pre-corrected schemas
✅ Consistent with other toolkit outputs  
✅ Can apply additional corrections via JSON cleanup
✅ Reproducible from saved JSON schemas
```

## Console Output

### Processing Status
```
Processing JSON Files from: json-exports
Configuration:
  Filter Underscore Tables: True
  Filter Underscore Columns: True
  Raw Table Retention: 1d
  Main Table Caching: 1d

Processing: GCP_DNS_CL
  JSON Schema: Found 45 columns for GCP_DNS_CL
  Applying data type corrections...
    TenantId: String -> Guid (corrected in JSON)
    payload_count_d: Double -> Real (ADX mapping)
  Column filtering: 45 total -> 42 final (3 underscore columns filtered)
  SUCCESS: Generated kql-from-json\GCP_DNS_CL.kql

Export Summary:
===============
SUCCESS: 12/12 JSON files processed  
FAILED: 0/12 JSON files failed

Files Location: kql-from-json\
Next Steps: Deploy .kql scripts in Azure Data Explorer
```

## Troubleshooting

### Common Issues
- **JSON files not found**: Run `log-analytics-schema-export.ps1` first
- **Invalid JSON format**: Check JSON schema structure
- **Type conversion errors**: Verify JSON has correct corrected types
- **ADX deployment failures**: Check cluster permissions and syntax

### Error Resolution
- **Schema parsing failures**: Validate JSON file format
- **Unknown types**: Check JSON type mappings in script
- **Column conflicts**: Review filtering settings
- **Update policy failures**: Verify expansion function syntax

## Advanced Configuration

### Custom Retention Policies
```powershell
$rawTableRetention = "7d"           # Longer raw data retention
$mainTableCaching = "3d"            # Extended cache for frequently accessed data
```

### Custom Column Filtering
```powershell
# Modify filtering logic in script
$filteredColumns = $columns | Where-Object { 
    # Custom filtering logic
    $_.name -notlike "*_internal_*"
}
```

### Alternative Ingestion Mappings
Generated scripts include mapping options for different JSON structures:
- **Nested records**: `$.records` path
- **Direct events**: `$` path  
- **Custom paths**: Modify mapping as needed

This script provides a JSON-schema-driven approach to ADX table generation, ensuring consistency with other toolkit outputs and leveraging pre-corrected schema definitions for accurate ADX deployments.
