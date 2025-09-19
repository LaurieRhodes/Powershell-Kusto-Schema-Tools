# log-analytics-to-json-export.ps1

## Overview

Exports Log Analytics table schemas to standardized JSON format using hybrid schema discovery. Creates Microsoft-compatible JSON files that serve as input for other PowerShell Kusto Schema Tools, enabling schema migration workflows across ADX, Log Analytics, and Bicep templates.

## Purpose

- **Schema Standardisation**: Export Log Analytics schemas to portable JSON format
- **Cross-Platform Migration**: Enable schema reuse across ADX, EventHouse and Log Analytics
- **Toolkit Integration**: Generate JSON input for json-to-* conversion scripts

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

- `$true`: Excludes reserved underscore columns like `_ResourceId`, `_BilledSize`, `_SubscriptionId`
- `$false`: Includes all columns in the JSON export
- Applied during JSON schema generation for consistent output

### Table Selection (when ExportAll = $false)

```powershell
$tablesToExport = @(
    'Anomalies',
    'CommonSecurityLog',
    'SecurityEvent',
    'Syslog',
    'WindowsEvent'
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

## JSON Output Format

### Schema Structure

**Location**: `json-exports\` directory
**Naming**: `{TableName}.json`
**Format**: Microsoft-compatible nested structure

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

## Type Mappings

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

# 