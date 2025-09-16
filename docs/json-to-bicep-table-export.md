# json-to-bicep-table-export.ps1

## Overview

Generates custom Log Analytics table Bicep templates from JSON schema files to allow the extension of Log Analytics with new Custom Log table types.

**Important** Custom Tables must allways be names with a trailing _CL to be importable into Log Analytics!

## Configuration Settings

### Input/Output Directories

```powershell
$jsonExportDirectory = Join-Path $PSScriptRoot "json-exports"     # Input JSON files
$outputDirectory = $PSScriptRoot                                  # Base output directory
$tablesDirectory = Join-Path $outputDirectory "bicep-tables"      # Table output directory
```

### Bicep Template Configuration

```powershell
$bicepConfig = @{
    DefaultLocation = "Australia East"              # Azure region
    DefaultWorkspaceName = "sentinel-workspace"     # Default workspace name
    TablePlan = "Analytics"                         # Table plan (Analytics/Basic/Auxiliary)
    RetentionInDays = 90                           # Data retention period
    TotalRetentionInDays = 2555                    # Total retention (including archive)
}
```

## Input Requirements

### JSON Schema Format

**Source**: Output from tools in this collection
**Location**: `json-exports\` directory
**Format**: Microsoft-compatible nested schema with corrected data types

**Expected Input Structure**:

```json
{
  "Name": "GCP_DNS_CL",
  "Properties": [
    {
      "Name": "TenantId",
      "Type": "Guid",
      "dataTypeHint": 1
    },
    {
      "Name": "TimeGenerated",
      "Type": "DateTime"
    },
    {
      "Name": "_ResourceId", 
      "Type": "String",
      "dataTypeHint": 2
    },
    {
      "Name": "payload_count_d",
      "Type": "Double"
    }
  ]
}
```

## Outputs

### Generated File Structure

```
bicep-tables/
├── TableName_CL/
│   ├── table-TableName_CL.bicep           # Main Bicep template
│   ├── table-TableName_CL.parameters.json # Parameter file template
│   └── deploy-TableName_CL.ps1            # PowerShell deployment script
```

### Bicep Template Features

#### 1. Workspace Reference

```bicep
resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: workspaceName
}
```

#### 2. Custom Table Resource

```bicep
resource customTable 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = {
  parent: workspace
  name: 'GCP_DNS_CL'
  properties: {
    plan: 'Analytics'
    retentionInDays: 90
    totalRetentionInDays: 2555
    schema: {
      name: 'GCP_DNS_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'TenantId'
          type: 'string'
          dataTypeHint: 1
        }
        {
          name: '_ResourceId'
          type: 'string'
          dataTypeHint: 2
        }
        {
          name: 'payload_count_d'
          type: 'real'
        }
      ]
    }
  }
}
```

## Data Type Mappings

### JSON to Bicep Type Conversion

| JSON Schema Type | Bicep Type | DataTypeHint | Usage                         |
| ---------------- | ---------- | ------------ | ----------------------------- |
| `String`         | `string`   | -            | Standard text                 |
| `DateTime`       | `dateTime` | -            | Timestamps                    |
| `Guid`           | `string`   | `1`          | GUIDs (TenantId, WorkspaceId) |
| `Double`         | `real`     | -            | Numeric values                |
| `Int`            | `int`      | -            | Integer values                |
| `Long`           | `long`     | -            | Large integers                |
| `Boolean`        | `boolean`  | -            | True/false values             |
| `Dynamic`        | `dynamic`  | -            | JSON objects/arrays           |

### DataTypeHint Values

Based on empirical deployment testing:

```powershell
0 = "Uri"           # URL/URI fields
1 = "Guid"          # GUID fields (TenantId, WorkspaceId)
2 = "ArmPath"       # Azure Resource Manager paths (_ResourceId)
3 = "IP"            # IP address fields
```

### Special Column Handling

- **TenantId**: Always gets `dataTypeHint: 1` (Guid)
- **WorkspaceId**: Always gets `dataTypeHint: 1` (Guid)
- **_ResourceId**: Always gets `dataTypeHint: 2` (ARM path)
- **TimeGenerated**: Required `dateTime` type for all custom tables

## Reserved Column Processing

### System-Managed Columns

These are automatically added by Azure and shouldn't be in custom schemas:

- `TenantId` - Added automatically as Guid
- `SourceSystem` - Added automatically  
- `MG` - Added automatically
- `ManagementGroupName` - Added automatically
- `Computer` - Added automatically
- `RawData` - Added automatically

### Column Filtering Logic

```powershell
# Keep essential columns but filter problematic ones
$allowedSystemColumns = @('TimeGenerated', '_ResourceId', '_BilledSize', '_IsBillable')
$filteredColumns = $columns | Where-Object { 
    -not $_.name.StartsWith("_") -or $_.name -in $allowedSystemColumns
}
```

## Parameter File Template

### Generated Parameters

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0", 
  "parameters": {
    "location": { "value": "Australia East" },
    "workspaceName": { "value": "sentinel-workspace" },
    "tableName": { "value": "GCP_DNS_CL" },
    "retentionInDays": { "value": 90 },
    "totalRetentionInDays": { "value": 2555 }
  }
}
```

### PowerShell Deployment Script

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true)] 
    [string]$WorkspaceName,

    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "table-GCP_DNS_CL.parameters.json"
)

$deploymentName = "table-GCP_DNS_CL-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Deploying custom table: GCP_DNS_CL" -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "table-GCP_DNS_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
```

## Prerequisites

### Required Files

- **Input**: JSON schema files in `json-exports\` directory  
- **Module**: `LogAnalyticsCommon.psm1` in same directory

### PowerShell Modules

```powershell
Install-Module Az.Accounts
Install-Module Az.OperationalInsights
```

### Azure Permissions

- **Contributor** access to Log Analytics workspace

### Table Plan Considerations

#### Analytics Plan (Default)

- **Best for**: Continuous monitoring, real-time analytics, Sentinel alerting
- **Query performance**: Optimised for complex multi-table queries
- **Retention**: 30 days to 2 years
- **Cost**: Higher ingestion cost, better query performance

#### Basic Plan

- **Best for**: Troubleshooting, incident response
- **Query performance**: Optimised for single-table queries  
- **Retention**: Up to 8 days
- **Cost**: Lower ingestion cost

#### Auxiliary Plan

- **Best for**: Verbose logs, compliance data
- **Query performance**: Non-optimised queries
- **Retention**: Up to 7 years  
- **Cost**: Lowest ingestion cost

### Workspace-Specific Configuration

```powershell
# Different settings per environment
$bicepConfig = @{
    DefaultWorkspaceName = "prod-sentinel"
    RetentionInDays = 365              # Longer retention for production
    TablePlan = "Analytics"
}
```
