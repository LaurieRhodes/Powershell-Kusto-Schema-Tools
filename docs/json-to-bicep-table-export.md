# json-to-bicep-table-export.ps1

## Overview
Generates custom Log Analytics table Bicep templates from JSON schema files with empirical deployment fixes. Creates production-ready custom table definitions with correct data types, dataTypeHints, and deployment configurations.

## Purpose
- **Custom Table Creation**: Generate Bicep templates for Log Analytics custom tables
- **Data Type Accuracy**: Apply empirical corrections for deployment compatibility
- **DataTypeHint Integration**: Add integer hints for proper column interpretation
- **Complete Deployment**: Templates with parameters, scripts, and validation

## Key Features
- ✅ **Empirical Data Type Fixes**: Based on real deployment testing
- ✅ **DataTypeHint Logic**: Integer hints for Guid (1), ARM paths (2), IP addresses (3)
- ✅ **Reserved Column Handling**: Proper handling of system-managed columns
- ✅ **Complete Packages**: Bicep + parameters + deployment scripts
- ✅ **Production Ready**: Analytics plan, retention policies, validated schemas

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

### Processing Settings
```powershell
$ErrorActionPreference = "Stop"                    # Strict error handling
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
| JSON Schema Type | Bicep Type | DataTypeHint | Usage |
|------------------|------------|--------------|-------|
| `String` | `string` | - | Standard text |
| `DateTime` | `dateTime` | - | Timestamps |
| `Guid` | `string` | `1` | GUIDs (TenantId, WorkspaceId) |
| `Double` | `real` | - | Numeric values |
| `Int` | `int` | - | Integer values |
| `Long` | `long` | - | Large integers |
| `Boolean` | `boolean` | - | True/false values |
| `Dynamic` | `dynamic` | - | JSON objects/arrays |

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
- **Permission** to create custom tables

### JSON Schema Source
```powershell
# Generate input files first
.\log-analytics-schema-export.ps1

# Optional: Apply additional corrections  
.\json-schema-cleanup.ps1
```

## Usage Examples

### Generate Tables for All JSON Files
```powershell
# Ensure JSON files exist
.\log-analytics-schema-export.ps1

# Generate table templates
.\json-to-bicep-table-export.ps1
```

### Deploy Generated Table
```powershell
# Navigate to table directory
cd bicep-tables\GCP_DNS_CL

# Update parameters with real values
# Edit table-GCP_DNS_CL.parameters.json

# Deploy using generated script
.\deploy-GCP_DNS_CL.ps1 -ResourceGroupName "my-rg" -WorkspaceName "my-workspace"
```

### Bulk Table Deployment
```powershell
# Deploy all generated tables
$resourceGroup = "my-resource-group"
$workspace = "my-workspace"

Get-ChildItem "bicep-tables" -Directory | ForEach-Object {
    $tableName = $_.Name
    Write-Host "Deploying $tableName..."
    
    Set-Location $_.FullName
    .\deploy-$tableName.ps1 -ResourceGroupName $resourceGroup -WorkspaceName $workspace
    Set-Location ..
}
```

## Integration Workflow

### Complete Table Creation Process
```
1. log-analytics-schema-export.ps1     →  JSON schemas
2. json-schema-cleanup.ps1 (optional)  →  Cleaned schemas
3. json-to-bicep-table-export.ps1      →  Table Bicep templates  
4. Deploy tables                       →  Custom Log Analytics tables
5. json-to-bicep-dcr-export.ps1        →  DCR templates for ingestion
```

### Table Plan Considerations

#### Analytics Plan (Default)
- **Best for**: Continuous monitoring, real-time analytics
- **Query performance**: Optimized for complex multi-table queries
- **Retention**: 30 days to 2 years
- **Cost**: Higher ingestion cost, better query performance

#### Basic Plan
- **Best for**: Troubleshooting, incident response
- **Query performance**: Optimized for single-table queries  
- **Retention**: Up to 8 days
- **Cost**: Lower ingestion cost

#### Auxiliary Plan  
- **Best for**: Verbose logs, compliance data
- **Query performance**: Non-optimized queries
- **Retention**: Up to 7 years  
- **Cost**: Lowest ingestion cost

## Console Output

### Processing Status
```
Processing: GCP_DNS_CL
    Reading JSON schema from file...
    JSON Schema: Found 45 columns for GCP_DNS_CL
    Applying empirical data type corrections...
      Fixed: TenantId String -> Guid (Microsoft API bug)
      Fixed: payload_count_d Double -> real (Bicep compatibility)
    Adding dataTypeHints based on empirical testing...
      TenantId: dataTypeHint = 1 (Guid)
      _ResourceId: dataTypeHint = 2 (ARM path)
    Generating table schema...
  SUCCESS: 45 total columns -> 43 table columns (filtered system columns)
    Table Plan: Analytics (90 day retention)
    Files: bicep-tables\GCP_DNS_CL
```

### Export Summary
```
Export Summary:
===============
SUCCESS: 15/15 JSON files processed
FAILED: 0/15 JSON files failed

Successful Exports:
  * GCP_DNS_CL: 43 columns (Custom table, Analytics plan)
  * ZeroFoxAlertPoller_CL: 48 columns (Custom table, Analytics plan)
  * CommonSecurityLog: 67 columns (Standard table, Analytics plan)

Table Plan Distribution:
  Analytics: 15 tables (optimized for monitoring)
  Basic: 0 tables
  Auxiliary: 0 tables
```

## Troubleshooting

### Common Issues
- **JSON files not found**: Run schema export script first
- **Reserved column errors**: Check system column filtering
- **DataType validation failures**: Verify empirical type mappings
- **Deployment permission errors**: Check workspace contributor access

### Error Resolution
- **Schema validation failures**: Re-run with corrected JSON input
- **DataTypeHint errors**: Check integer hint values (0-3 only)
- **Column name conflicts**: Verify no duplicate column names
- **Retention errors**: Check retention values are within limits

## Advanced Configuration

### Custom Table Plans
```powershell
$bicepConfig = @{
    TablePlan = "Basic"                 # For troubleshooting workloads
    RetentionInDays = 8                # Basic plan maximum
}
```

### Custom Data Types
The script handles empirical mappings but can be extended:
```powershell
# Add custom type mappings in the script
switch ($jsonType) {
    'CustomType' { return 'string' }    # Map to appropriate Bicep type
}
```

### Workspace-Specific Configuration
```powershell
# Different settings per environment
$bicepConfig = @{
    DefaultWorkspaceName = "prod-sentinel"
    RetentionInDays = 365              # Longer retention for production
    TablePlan = "Analytics"
}
```

This script provides production-ready custom table deployments with empirically validated configurations that ensure successful Log Analytics table creation and optimal performance characteristics.
