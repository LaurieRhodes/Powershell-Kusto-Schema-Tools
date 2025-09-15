# adx-to-json-export.ps1

## Overview
Exports Azure Data Explorer (ADX) table schemas to JSON format using direct ADX REST API calls. Creates standardized JSON schema files compatible with other toolkit scripts for downstream processing into KQL, Bicep DCR, or Bicep table formats.

## Purpose
- **ADX Schema Export**: Extract table schemas directly from Azure Data Explorer clusters
- **JSON Standardization**: Create Microsoft-compatible JSON format for cross-platform use
- **Schema Migration**: Enable ADX → Log Analytics table migration workflows
- **Toolkit Integration**: Generate JSON input for other PowerShell Kusto Schema Tools

## Key Features
- ✅ **Direct ADX API**: Uses ADX REST API with Kusto authentication
- ✅ **Simple Two-Step Process**: List tables → Get schema for each table
- ✅ **Microsoft Ordering**: Follows TimeGenerated first, Type last convention
- ✅ **Type Conversion**: Maps ADX types to Log Analytics-compatible JSON types
- ✅ **Filtering Options**: Configurable underscore table/column filtering
- ✅ **Error Resilience**: Continues processing when individual tables fail

## Configuration Settings

### ADX Connection
```powershell
# UPDATE THESE VALUES FOR YOUR ENVIRONMENT
$adxClusterUri = "https://YOUR-CLUSTER-NAME.YOUR-REGION.kusto.windows.net"
$adxDatabase = "YOUR-DATABASE-NAME"
```

**Example Configuration**:
```powershell
$adxClusterUri = "https://securitylogs.australiasoutheast.kusto.windows.net"
$adxDatabase = "security"
```

### Output Configuration
```powershell
$outputDirectory = Join-Path $PSScriptRoot "json-exports-from-adx"
$ErrorActionPreference = "Stop"
```

## Authentication Requirements

### Azure Authentication
The script uses Azure authentication with Kusto resource scope:
```powershell
if (-not (Get-AzContext)) { Connect-AzAccount }
$token = Get-SafeAccessToken -ResourceUrl "https://kusto.kusto.windows.net/"
```

**Prerequisites**:
- Azure PowerShell authentication (`Connect-AzAccount`)
- Read access to ADX cluster and database
- `LogAnalyticsCommon.psm1` module in same directory

## ADX API Operations

### Step 1: Table Discovery
**API Call**: ADX Management API
**Query**: `.show tables | project TableName`
**Purpose**: Get list of all tables in database

```kusto
.show tables | project TableName
```

**Filtering**: Automatically excludes tables starting with underscore (`_`)

### Step 2: Schema Extraction  
**API Call**: ADX Query API
**Query**: `{TableName} | getschema`
**Purpose**: Get detailed schema for each table

```kusto
SecurityEvent | getschema
```

**Returns**: ColumnName, ColumnOrdinal, DataType, ColumnType

## Data Type Mappings

### ADX to JSON Type Conversion
The script converts ADX data types to Log Analytics-compatible JSON types:

| ADX Type | JSON Type | Notes |
|----------|-----------|-------|
| `string` | `String` | Text fields |
| `datetime` | `DateTime` | Timestamps |
| `int` | `Int` | 32-bit integers |
| `long` | `Long` | 64-bit integers |
| `real` | `Double` | Floating point numbers |
| `bool` | `Boolean` | True/false values |
| `boolean` | `Boolean` | Alternative boolean type |
| `dynamic` | `Dynamic` | JSON objects/arrays |
| `guid` | `Guid` | Unique identifiers |
| `timespan` | `TimeSpan` | Duration values |
| `decimal` | `Double` | Decimal numbers → Double |

**Unknown Types**: Default to `String` with warning message

## Output Format

### JSON Schema Structure
**Location**: `json-exports-from-adx\` directory
**Naming**: `{TableName}.json`
**Format**: Microsoft-compatible nested structure

**Example Output**:
```json
{
  "Name": "SecurityEvent",
  "Properties": [
    {
      "Name": "TimeGenerated",
      "Type": "DateTime"
    },
    {
      "Name": "Account",
      "Type": "String"
    },
    {
      "Name": "EventID", 
      "Type": "Int"
    },
    {
      "Name": "Type",
      "Type": "String"
    },
    {
      "Name": "_ResourceId",
      "Type": "String"
    }
  ]
}
```

### Column Ordering Convention
Follows Microsoft's standardized ordering:

1. **TimeGenerated** - Always first if present
2. **Regular columns** - Alphabetical order
3. **Type column** - Special Microsoft column if present
4. **Underscore columns** - System columns (`_ResourceId`, etc.)

**Filtered**: `_TimeReceived` column automatically excluded

## Processing Flow

### Discovery Process
```
1. Connect to ADX cluster
2. Query: .show tables | project TableName
3. Filter out underscore tables
4. For each table:
   a. Query: TableName | getschema
   b. Extract column definitions
   c. Apply type mappings
   d. Apply Microsoft ordering
   e. Generate JSON schema
   f. Save to file
```

### Error Handling
- **Individual table failures**: Continue processing remaining tables
- **Connection failures**: Stop execution with clear error
- **Schema parsing errors**: Log warning and skip table
- **File system errors**: Report and continue

## Usage Examples

### Basic Export
```powershell
# 1. Configure ADX connection details in script
# 2. Ensure Azure authentication
Connect-AzAccount

# 3. Run export
.\adx-to-json-export.ps1
```

### Verify Output
```powershell
# Check generated files
Get-ChildItem "json-exports-from-adx\*.json" | Select-Object Name, Length

# View sample schema
Get-Content "json-exports-from-adx\SecurityEvent.json" | ConvertFrom-Json
```

### Integration with Other Scripts
```powershell
# Export from ADX
.\adx-to-json-export.ps1

# Convert to Log Analytics KQL
.\json-to-adx-kql-export.ps1

# Convert to Bicep DCR
.\json-to-bicep-dcr-export.ps1
```

## Output Directory Structure
```
json-exports-from-adx\
├── SecurityEvent.json
├── Syslog.json
├── CommonSecurityLog.json
├── WindowsEvent.json
└── [OtherTable].json
```

## Console Output

### Processing Status
```
ADX to JSON Export - Simplified Version
Cluster: https://securitylogs.australiasoutheast.kusto.windows.net
Database: security

Getting table list...
Found 47 tables
Sample tables: SecurityEvent, Syslog, CommonSecurityLog, WindowsEvent, Heartbeat...

Exporting schemas...
Processing: SecurityEvent
  SUCCESS: 45 -> 44 columns (filtered _TimeReceived) -> SecurityEvent.json
Processing: Syslog
  SUCCESS: 23 -> 23 columns -> Syslog.json
Processing: CommonSecurityLog
  SUCCESS: 38 -> 38 columns -> CommonSecurityLog.json

Completed: 47/47 tables exported
Output directory: D:\Github\Powershell-Kusto-Schema-Tools\json-exports-from-adx

Features Applied:
- Filtered out _TimeReceived column
- Microsoft column ordering (TimeGenerated first, Type last, underscore columns at end)
- Proper JSON type casing (String, DateTime, etc.)
- Correct JSON structure (Name first, Properties second)
- Compatible with json-to-* export scripts
```

## Integration Workflows

### ADX to Log Analytics Migration
```
1. adx-to-json-export.ps1           →  Export ADX schemas to JSON
2. json-to-bicep-table-export.ps1   →  Create Log Analytics table definitions
3. Deploy Bicep templates           →  Create tables in Log Analytics
4. json-to-bicep-dcr-export.ps1     →  Create data ingestion pipelines
```

### Schema Analysis and Comparison
```
1. adx-to-json-export.ps1           →  Export ADX schemas
2. log-analytics-to-json-export.ps1 →  Export Log Analytics schemas  
3. Compare JSON files               →  Identify differences
4. Plan migration strategy          →  Address schema differences
```

### Cross-Platform Schema Replication
```
1. adx-to-json-export.ps1           →  Export from source ADX
2. json-to-adx-kql-export.ps1       →  Generate KQL for target ADX
3. Deploy KQL scripts               →  Replicate schema structure
```

## Troubleshooting

### Common Issues

**"Configuration values cannot be empty"**
- Update `$adxClusterUri` and `$adxDatabase` with your actual values
- Ensure cluster URI includes https:// and full domain

**Authentication failures**
- Run `Connect-AzAccount` before executing script
- Verify you have read access to the ADX cluster
- Check if cluster requires specific tenant authentication

**"No tables found after filtering"**
- Verify database name is correct
- Check if all tables start with underscore (they get filtered)
- Confirm database contains tables you can access

**API connection errors**
- Verify cluster URI format: `https://clustername.region.kusto.windows.net`
- Check network connectivity to ADX cluster
- Ensure cluster is not in a private network

**Schema parsing errors**
- Check ADX cluster version compatibility
- Verify table permissions (some system tables may be restricted)
- Look for non-standard column types

### Debug Mode
Enable verbose logging:
```powershell
$VerbosePreference = "Continue"
.\adx-to-json-export.ps1
```

### Manual Verification
Test ADX connection manually:
```kusto
// In ADX Web UI or Kusto Explorer
.show tables | project TableName | limit 10

// Test specific table schema
YourTableName | getschema
```

## Advanced Configuration

### Custom Filtering
Modify the script to include underscore tables:
```powershell
# In the table filtering section, change:
if (-not $tableName.StartsWith("_")) {  # Skip underscore tables
    $tableNames += $tableName
}

# To:
$tableNames += $tableName  # Include all tables
```

### Custom Type Mappings
Add new ADX type mappings in `Convert-ADXTypeToJSONType` function:
```powershell
switch ($adxType.ToLower()) {
    'your_custom_type' { return 'String' }
    # ... existing mappings
}
```

### Different Output Directory
```powershell
$outputDirectory = "C:\MyCustomPath\adx-schemas"
```

## Prerequisites Summary

- **Azure PowerShell**: `Az.Accounts` module installed
- **Authentication**: Valid Azure account with ADX access
- **Permissions**: Read access to ADX cluster and database
- **Network**: Connectivity to ADX cluster endpoint
- **Dependencies**: `LogAnalyticsCommon.psm1` module in same directory

## API Endpoints Used

### Management API
- **URL**: `{cluster}/v1/rest/mgmt`
- **Purpose**: Table discovery
- **Authentication**: Bearer token from `https://kusto.kusto.windows.net/`

### Query API  
- **URL**: `{cluster}/v2/rest/query`
- **Purpose**: Schema extraction
- **Authentication**: Bearer token from `https://kusto.kusto.windows.net/`

This script provides a reliable method for extracting ADX table schemas into standardized JSON format, enabling seamless integration with the broader PowerShell Kusto Schema Tools ecosystem for cross-platform schema management and migration workflows.
