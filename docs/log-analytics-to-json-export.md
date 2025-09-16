# log-analytics-to-json-export.ps1

## Overview

Exports Log Analytics table schemas to standardized JSON format using hybrid schema discovery. Creates Microsoft-compatible JSON files that serve as input for other PowerShell Kusto Schema Tools, enabling schema migration workflows across ADX, Log Analytics, and Bicep templates.

## Purpose

- **Schema Standardization**: Export Log Analytics schemas to portable JSON format
- **Cross-Platform Migration**: Enable schema reuse across ADX, DCR, and table deployments
- **Enhanced Discovery**: Use hybrid Management API + getschema for complete coverage  
- **Toolkit Integration**: Generate JSON input for json-to-* conversion scripts

## Key Features

- ✅ **Hybrid Schema Discovery**: Combines Management API + getschema for maximum coverage
- ✅ **Configurable Export Scope**: Export all tables or specific table lists
- ✅ **Column Filtering**: Configurable inclusion/exclusion of underscore columns
- ✅ **Microsoft Ordering**: Follows TimeGenerated first, Type last column conventions
- ✅ **Empirical Corrections**: Built-in fixes for Microsoft API data type bugs
- ✅ **Future-Compatible Authentication**: Handles current and future Az.Accounts versions

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

### Export Configuration

```powershell
$ExportAll = $true                    # Set to $true to export ALL workspace tables
```

### Column Filtering Options

```powershell
$FilterUnderscoreColumns = $false     # Set to $false to include underscore columns in JSON
```

#### Export Modes

**Export All Mode** (`$ExportAll = $true`):
- Automatically discovers all tables in the workspace
- Exports every table found
- Ignores the `$tablesToExport` list
- Ideal for comprehensive workspace exports

**Specific Tables Mode** (`$ExportAll = $false`):
- Uses the configured `$tablesToExport` list
- Only exports explicitly listed tables
- Better for targeted exports or testing

#### Column Filtering

**Filter Underscore Columns** (`$FilterUnderscoreColumns`):
- `$true`: Excludes underscore columns like `_ResourceId`, `_BilledSize`, `_SubscriptionId`
- `$false`: Includes all columns in the JSON export
- Applied during JSON schema generation for consistent output

### Table Selection (when ExportAll = $false)

```powershell
$tablesToExport = @(
    'Anomalies',
    'CommonSecurityLog',
    'SecurityEvent',
    'Syslog',
    'WindowsEvent',
    'OktaV2_CL',
    'GCP_DNS_CL',
    'ZeroFoxAlertPoller_CL'
)
```

### Output Configuration

```powershell
$outputDirectory = $PSScriptRoot
$jsonDirectory = Join-Path $outputDirectory "json-exports"
```

### Discovery Settings

```powershell
$useHybridDiscovery = $true           # Use both Management API + getschema
$preferManagementAPITypes = $true     # Prefer Management API types over getschema
```

## Schema Discovery Process

### Hybrid Discovery Workflow

```
1. Management API Discovery
   ├── Call: GET /workspaces/{workspace}/tables/{table}
   ├── Extract: standardColumns + customColumns
   ├── Get: tableType (CustomLog, Microsoft, etc.)
   └── Source: "ManagementAPI"

2. getschema Discovery (if enabled)
   ├── Query: {TableName} | getschema
   ├── Extract: additional columns not in Management API
   ├── Apply: empirical type corrections
   └── Source: "GetSchema"

3. Merge Results
   ├── Combine: both column sources
   ├── Prefer: Management API types
   ├── Report: additional columns found
   └── Output: complete column set

4. Column Filtering (if enabled)
   ├── Apply: $FilterUnderscoreColumns setting
   ├── Remove: underscore columns if filtering enabled
   └── Output: filtered column set for JSON
```

### Empirical Corrections Applied

Built-in fixes for known Microsoft API bugs:

| Column Name       | API Type | Corrected Type | Reason            |
| ----------------- | -------- | -------------- | ----------------- |
| `TenantId`        | `string` | `guid`         | Microsoft API bug |
| `WorkspaceId`     | `string` | `guid`         | Microsoft API bug |
| `TimeGenerated`   | `string` | `datetime`     | Microsoft API bug |
| All `*_d` columns | `double` | `real`         | ADX/LA standard   |

## JSON Output Format

### Schema Structure

**Location**: `json-exports\` directory
**Naming**: `{TableName}.json`
**Format**: Microsoft-compatible nested structure

**Example Output** (with `$FilterUnderscoreColumns = $false`):

```json
{
  "Name": "CommonSecurityLog",
  "Properties": [
    {
      "Name": "TimeGenerated",
      "Type": "DateTime"
    },
    {
      "Name": "Activity",
      "Type": "String"
    },
    {
      "Name": "ApplicationProtocol", 
      "Type": "String"
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

**Example Output** (with `$FilterUnderscoreColumns = $true`):

```json
{
  "Name": "CommonSecurityLog",
  "Properties": [
    {
      "Name": "TimeGenerated",
      "Type": "DateTime"
    },
    {
      "Name": "Activity",
      "Type": "String"
    },
    {
      "Name": "ApplicationProtocol", 
      "Type": "String"
    },
    {
      "Name": "Type",
      "Type": "String"
    }
  ]
}
```

### Type Mappings

Log Analytics types convert to JSON types following Microsoft conventions:

| Log Analytics Type | JSON Type  | Usage               |
| ------------------ | ---------- | ------------------- |
| `string`           | `String`   | Text fields         |
| `datetime`         | `DateTime` | Timestamps          |
| `int`              | `Int`      | 32-bit integers     |
| `long`             | `Long`     | 64-bit integers     |
| `real`             | `Double`   | Floating point      |
| `bool`             | `Boolean`  | True/false values   |
| `boolean`          | `Boolean`  | Alternative boolean |
| `dynamic`          | `Dynamic`  | JSON objects/arrays |
| `guid`             | `Guid`     | Unique identifiers  |
| `timespan`         | `TimeSpan` | Duration values     |

### Column Ordering Convention

Follows Microsoft's standardized ordering:

1. **TimeGenerated** - Always first if present
2. **Regular columns** - Alphabetical order
3. **Type column** - Special Microsoft column if present  
4. **Underscore columns** - System columns (`_ResourceId`, etc.) - only if not filtered

This ordering ensures consistency with other Microsoft tooling and export formats.

## Usage Examples

### Export All Workspace Tables (Include All Columns)

```powershell
# Configure for complete workspace export with all columns
$ExportAll = $true
$FilterUnderscoreColumns = $false

# Run export
.\log-analytics-to-json-export.ps1
```

### Export All Workspace Tables (Exclude Underscore Columns)

```powershell
# Configure for workspace export without system columns
$ExportAll = $true
$FilterUnderscoreColumns = $true

# Run export
.\log-analytics-to-json-export.ps1
```

### Export Specific Security Tables

```powershell
# Configure for targeted export
$ExportAll = $false
$FilterUnderscoreColumns = $false

$tablesToExport = @(
    'SecurityEvent',
    'CommonSecurityLog',
    'Syslog',
    'WindowsEvent'
)

# Run export
.\log-analytics-to-json-export.ps1
```

### Export Custom Tables Only (Clean Schema)

```powershell
# Configure for custom tables without system columns
$ExportAll = $false
$FilterUnderscoreColumns = $true

$tablesToExport = @(
    'OktaV2_CL',
    'GCP_DNS_CL',
    'ZeroFoxAlertPoller_CL'
)

# Run export
.\log-analytics-to-json-export.ps1
```

## Integration Workflows

### JSON as Schema Hub

```
1. log-analytics-to-json-export.ps1     →  JSON schemas (source of truth)
2. json-to-adx-kql-export.ps1           →  ADX table creation scripts
3. json-to-bicep-dcr-export.ps1         →  Data Collection Rules
4. json-to-bicep-table-export.ps1       →  Log Analytics table definitions
```

### Cross-Platform Migration

```
Source LA Workspace → JSON Schemas → Target Platforms
                         ↓
                    ┌─────────────┬─────────────┬─────────────┐
                    ↓             ↓             ↓             ↓
                ADX Tables    DCR Templates   LA Tables    Documentation
```

### Schema Comparison and Analysis

```powershell
# Export from multiple environments
.\log-analytics-to-json-export.ps1    # Production
# Change workspace configuration
.\log-analytics-to-json-export.ps1    # Development

# Compare JSON files for schema drift analysis
```

## Console Output

### Processing Status

```
Log Analytics to JSON Export Script - UPDATED VERSION
====================================================

Configuration:
  Workspace: SentinelAUE
  Resource Group: sentinel
  Subscription: 2be53ae5-6e46-47df-beb9-6f3a795387b8
  Export All Tables: True
  Filter Underscore Columns: True
  Hybrid Discovery: True

Testing prerequisites and authentication...
SUCCESS: Authenticated as user@company.com

Acquiring access tokens...
SUCCESS: Management API token acquired
SUCCESS: Log Analytics API token acquired
SUCCESS: Workspace GUID: 12345678-1234-1234-1234-123456789abc

Discovering all workspace tables...
  Found 147 tables in workspace
SUCCESS: Found 147 tables to export

Exporting 147 tables (showing first 15):
  * Anomalies
  * ASimAuditEventLogs
  * ASimAuthenticationEventLogs
  * CommonSecurityLog
  * SecurityEvent
  * Syslog
  * WindowsEvent
  * OktaV2_CL
  * GCP_DNS_CL
  * ZeroFoxAlertPoller_CL
  ... and 137 more

Generating JSON schemas...
Processing: CommonSecurityLog
    Management API: Found 42 columns
    getschema: Found 45 columns
    Merge result: 42 from Management API + 3 additional from getschema = 45 total
    Additional columns discovered:
      + CustomField1 (string)
      + CustomField2 (dynamic)
      + CustomField3 (datetime)
    Filtered out 5 underscore columns
  SUCCESS: 45 total columns -> 40 JSON columns (42 mgmt, 3 additional) -> CommonSecurityLog.json (filtered)

Processing: SecurityEvent
    Management API: Found 45 columns
    getschema: Found 45 columns
    Merge result: 45 from Management API + 0 additional from getschema = 45 total
    Filtered out 3 underscore columns
  SUCCESS: 45 total columns -> 42 JSON columns (45 mgmt, 0 additional) -> SecurityEvent.json (filtered)

Export Summary:
===============
SUCCESS: 147/147 tables exported
FAILED: 0/147 tables failed
Additional columns discovered: 15

Successful Exports:
  * Anomalies: 8 total columns -> 8 JSON columns
  * CommonSecurityLog: 45 total columns -> 40 JSON columns (+3 additional)
  * SecurityEvent: 45 total columns -> 42 JSON columns
  * Syslog: 38 total columns -> 35 JSON columns (+2 additional)
  ... (143 more tables)

Configuration Options:
- Set $ExportAll = $true to export all workspace tables
- Set $ExportAll = $false to use the configured table list
- Set $FilterUnderscoreColumns = $false to include underscore columns

JSON files created in json-exports\ directory for use with json-to-* scripts.
JSON Export completed with enhanced discovery capabilities.
```

## Prerequisites

### Azure Environment

- **Log Analytics workspace**: Source of schema information
- **Azure PowerShell**: `Az.Accounts`, `Az.OperationalInsights` modules
- **Authentication**: Valid Azure account with workspace access

### Permissions Required

- **Log Analytics workspace**: Reader access
- **Resource group**: Reader access (for Management API calls)
- **Subscription**: Reader access (for workspace enumeration)

### Dependencies

- **Module**: `LogAnalyticsCommon.psm1` in same directory
- **Authentication**: Valid Azure authentication context

## Advanced Configuration

### Custom Discovery Settings

```powershell
# Disable hybrid discovery for faster processing
$useHybridDiscovery = $false

# Prefer getschema types over Management API
$preferManagementAPITypes = $false
```

### Custom Column Filtering

Modify filtering logic for specific requirements:

```powershell
# Custom column filtering example in New-OrderedJSONSchema function
# Example: Filter columns containing 'internal' in name
$customFilteredColumns = $columnDefinitions | Where-Object { 
    $_.name -notlike "*internal*" 
}
```

### Output Directory Customization

```powershell
$jsonDirectory = "C:\Schemas\LogAnalytics\$(Get-Date -Format 'yyyy-MM-dd')"
```

## Troubleshooting

### Common Issues

**"Configuration values cannot be empty"**

- Update workspace name, resource group, and subscription ID with actual values
- Ensure all placeholder values are replaced

**Authentication failures**

- Run `Connect-AzAccount` and verify successful authentication
- Check Log Analytics workspace access permissions
- Verify subscription context is correct

**"No tables found"**

- Check workspace name spelling and case sensitivity
- Verify workspace exists in specified resource group
- Confirm you have read access to the workspace

**getschema query failures**

- Some tables may not support getschema queries
- Check table permissions and access restrictions
- Verify workspace GUID is correct

### Performance Optimization

**Large workspace exports**

- Consider setting `$ExportAll = $false` for targeted exports
- Use `$useHybridDiscovery = $false` to reduce API calls
- Process tables in smaller batches if needed

**API rate limiting**

- Script includes built-in error handling for API limits
- Large workspaces may take several minutes to process
- Monitor console output for throttling messages

### JSON Validation

```powershell
# Validate generated JSON files
Get-ChildItem "json-exports\*.json" | ForEach-Object {
    try {
        Get-Content $_.FullName | ConvertFrom-Json | Out-Null
        Write-Host "✓ $($_.Name)" -ForegroundColor Green
    } catch {
        Write-Host "✗ $($_.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}
```

## Output Analysis

### Schema Statistics

```powershell
# Analyze exported schemas
$jsonFiles = Get-ChildItem "json-exports\*.json"
$totalTables = $jsonFiles.Count

$stats = $jsonFiles | ForEach-Object {
    $schema = Get-Content $_.FullName | ConvertFrom-Json
    [PSCustomObject]@{
        TableName = $schema.Name
        ColumnCount = $schema.Properties.Count
        HasTimeGenerated = ($schema.Properties.Name -contains "TimeGenerated")
        HasType = ($schema.Properties.Name -contains "Type")
        UnderscoreColumns = ($schema.Properties.Name | Where-Object { $_ -like "_*" }).Count
    }
}

$stats | Format-Table -AutoSize
```

### Column Type Distribution

```powershell
# Analyze column types across all tables
$allColumns = Get-ChildItem "json-exports\*.json" | ForEach-Object {
    $schema = Get-Content $_.FullName | ConvertFrom-Json
    $schema.Properties
}

$typeStats = $allColumns | Group-Object Type | Sort-Object Count -Descending
$typeStats | Format-Table Name, Count -AutoSize
```

## Notes

- Log Analytics table names do not start with underscores (unlike some other systems)
- Custom tables have `_CL` suffix (e.g., `MyCustomTable_CL`)  
- Restored tables have `_RST` suffix (e.g., `SecurityEvent_RST`)
- The script focuses on actual table discovery rather than naming pattern filtering
- Underscore columns (like `_ResourceId`, `_BilledSize`) are valid data fields that can be optionally filtered
- The `$FilterUnderscoreColumns` setting provides flexibility for different use cases and downstream tool requirements

This script provides comprehensive Log Analytics schema export capabilities with flexible export modes, column filtering options, and robust discovery mechanisms, serving as the foundation for cross-platform schema migration and analysis workflows.