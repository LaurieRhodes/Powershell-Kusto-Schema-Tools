# ADX-to-JSON-export.ps1

## Overview

Exports Azure Data Explorer (ADX) table schemas to JSON format. Creates standardised JSON schema files compatible with other toolkit scripts for downstream processing into KQL, Bicep DCR, or Bicep table formats.

Note that this script is hardcoded to skip underscore prefaced columns as part of an export, as these are typically an indication of internal use only.  These may be re-inserted into JSON exports if required.

## Purpose

- **ADX Schema Export**: Extract table schemas directly from Azure Data Explorer clusters
- **Toolkit Integration**: Generates JSON input for other PowerShell Kusto Schema Tools

## Configuration Settings

### ADX Connection

```powershell
# UPDATE THESE VALUES FOR YOUR ENVIRONMENT
$adxClusterUri = "https://YOUR-CLUSTER-NAME.YOUR-REGION.kusto.windows.net"
$adxDatabase = "YOUR-DATABASE-NAME"
```

### Output Configuration

```powershell
$outputDirectory = Join-Path $PSScriptRoot "json-exports-from-adx"
```

## Prerequisites

- Azure PowerShell authentication (`Connect-AzAccount`)
- Read access to ADX cluster and database
- `LogAnalyticsCommon.psm1` module in same directory

## Data Type Mappings

### ADX to JSON Type Conversion

The script converts ADX data types to Log Analytics-compatible JSON types:

| ADX Type   | JSON Type  | Notes                    |
| ---------- | ---------- | ------------------------ |
| `string`   | `String`   | Text fields              |
| `datetime` | `DateTime` | Timestamps               |
| `int`      | `Int`      | 32-bit integers          |
| `long`     | `Long`     | 64-bit integers          |
| `real`     | `Double`   | Floating point numbers   |
| `bool`     | `Boolean`  | True/false values        |
| `boolean`  | `Boolean`  | Alternative boolean type |
| `dynamic`  | `Dynamic`  | JSON objects/arrays      |
| `guid`     | `Guid`     | Unique identifiers       |
| `timespan` | `TimeSpan` | Duration values          |
| `decimal`  | `Double`   | Decimal numbers → Double |

**Unknown Types**: Default to `String` with warning message

## Output Format

### JSON Schema Structure

**Location**: `json-exports-from-adx\` directory
**Naming**: `{TableName}.json`
**Format**: JSON nested structure



The nested JSON structure matches the format used by Microsoft Sentinel and their KQL Validation tests:  [Azure-Sentinel/.script/tests/KqlvalidationsTests/CustomTables at b53b5f0e5837da2d747319349cd2e81385c22a38 · Azure/Azure-Sentinel · GitHub](https://github.com/Azure/Azure-Sentinel/tree/b53b5f0e5837da2d747319349cd2e81385c22a38/.script/tests/KqlvalidationsTests/CustomTables)



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

**Filtered**: `_TimeReceived` column automatically excluded
