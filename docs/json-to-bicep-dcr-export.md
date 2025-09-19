# json-to-bicep-dcr-export.ps1

## Overview

Generates Data Collection Rule (DCR) Bicep templates from JSON schema files. 

Bicep templates manage the Transformation of incoming data to the data types expected by the target Log Analytics workspace.

**Important** created Bicep templates presume that the table for ingestion will be a Custom Analytics table.  The 'Custom' stream is set as such in the Bicep template.  You MUST ensure that the targeted table name includes a trailing _CL The small number of Microsoft managed tables that are actually open for writing (like Syslog and ASIM tables) have example DCR templates included in this archive.

## Purpose

- **DCR Automation**: Generate complete DCR deployments from corrected JSON schemas
- **Transform Generation**: Create proper KQL transform functions with correct type conversions
- **Reserved Column Filtering**: Automatically exclude illegal columns like `Type`
- **Deployment Packages**: Complete Bicep templates with parameters and deployment scripts

## Configuration Settings

### Input/Output Directories

```powershell
$jsonExportDirectory = Join-Path $PSScriptRoot "json-exports"    # Input JSON files
$outputDirectory = $PSScriptRoot                                 # Base output directory  
$dcrDirectory = Join-Path $outputDirectory "dcr-from-json"      # DCR output directory
```

### Column Filtering Options

**Note**: The Microsoft reserved 'Type' column is **always** filtered out regardless of this setting, as it causes DCR deployment failures.

### Bicep Template Configuration

```powershell
$bicepConfig = @{
    DefaultLocation = "Australia East"                         # Azure region
    DefaultWorkspaceName = "sentinel-prod"                     # Workspace name
    RoleDefinitionId = "3913510d-42f4-4e42-8a64-420c390055eb"  # Monitoring Metrics Publisher
}
```

The Bicep Template Configuration provides default examples for the Bicep files that are produced.  You are more likely to alter the Bicep Parameter files directly but this is useful to alter for large scale template creation.

## Input Requirements

### JSON Schema Format

**Source**: Output from `log-analytics-schema-export.ps1`
**Location**: `json-exports\` directory  
**Format**: Microsoft-compatible nested schema

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
    },
    {
      "Name": "Type",
      "Type": "String"
    }
  ]
}
```

## Outputs

### Generated File Structure

```
dcr-from-json/
├── TableName_CL/
│   ├── dcr-TableName_CL.bicep           # Main Bicep template
│   ├── dcr-TableName_CL.parameters.json # Parameter file template
```

### Bicep Template Features

#### 1. DCR Resource Definition

```bicep
resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-GCP_DNS_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-GCP_DNS_CL': {
        columns: [
          { name: 'TimeGenerated', type: 'string' }
          { name: 'TenantId', type: 'string' }
          { name: 'payload_vmInstanceId_d', type: 'string' }
          // _ResourceId: included/excluded based on $FilterUnderscoreColumns
          // Type column: always filtered out (DCR reserved)
        ]
      }
    }
    // ... rest of DCR configuration
  }
}
```

Notice that the stream declaration is always a 'Custom' stream.

#### 2. Transform KQL Generation

```bicep
transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), payload_vmInstanceId_d = toreal(payload_vmInstanceId_d)'
```

#### 3. Role Assignment

```bicep
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: dataCollectionRule
  name: guid(resourceGroup().id, roleDefinitionResourceId, dataCollectionRule.name)
  properties: {
    roleDefinitionId: roleDefinitionResourceId
    principalId: servicePrincipalObjectId
    principalType: 'ServicePrincipal'
  }
}
```

### Parameter File Template

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": { "value": "Australia East" },
    "dataCollectionEndpointId": { "value": "/subscriptions/{subscription-id}/..." },
    "workspaceResourceId": { "value": "/subscriptions/{subscription-id}/..." },
    "workspaceName": { "value": "sentinel-workspace" },
    "servicePrincipalObjectId": { "value": "{service-principal-object-id}" }
  }
}
```

The example template produced expects that you will have pre-provisioned a Data Collection Endpoint and a User Defined Managed Identity that you will use for forwarding data to Log Analytics.  

The Log Analytics Workspace you intend to receive events is specified by the workspaceResourceId parameter.

The workspaceName parameter is simply an identifier used in naming the DCR.  It's likely that CI/CD pipelines will have Dev / Test / Prod targets for Data Collection Rules so incorporating the name of the destination Log Analytics Workspace is helpful in easily identifying where data to a particular DCR actually goes. 

## Data Type Transformations

### Input Stream Types (JSON Compatible)

All input columns use JSON-compatible types for resilience:

```bicep
columns: [
  { name: 'TenantId', type: 'string' }        # Will convert with toguid()
  { name: 'TimeGenerated', type: 'string' }   # Will convert with todatetime()  
  { name: 'payload_count_d', type: 'string' }  # Will convert with toreal()
  { name: 'payload_enabled_b', type: 'string' } # Will convert with tobool()
]
```

### Transform Functions Generated

| JSON Type  | Transform Function | Target Type |
| ---------- | ------------------ | ----------- |
| `String`   | `tostring()`       | String      |
| `DateTime` | `todatetime()`     | DateTime    |
| `Guid`     | `toguid()`         | Guid        |
| `Double`   | `toreal()`         | Real        |
| `Int`      | `toint()`          | Int         |
| `Long`     | `tolong()`         | Long        |
| `Boolean`  | `tobool()`         | Boolean     |
| `Dynamic`  | `todynamic()`      | Dynamic     |

## Prerequisites

### Required Files

- **Input**: JSON schema files in `json-exports\` directory
- **Module**: `LogAnalyticsCommon.psm1` in same directory

### Log Analytics Table Expansion

Log Analytics tables must contain the custom table for the Data Collection Rule custom data prior to the DCR being deployed.  See the use of the included json-to-bicep-table-export.ps1 script for this purpose.
