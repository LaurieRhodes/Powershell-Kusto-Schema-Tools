# json-to-bicep-dcr-export.ps1

## Overview
Generates Data Collection Rule (DCR) Bicep templates from JSON schema files with empirical deployment fixes. Creates complete DCR deployment packages with correct transform functions, reserved column filtering, and production-ready configurations.

## Purpose
- **DCR Automation**: Generate complete DCR deployments from corrected JSON schemas
- **Transform Generation**: Create proper KQL transform functions with correct type conversions
- **Reserved Column Filtering**: Automatically exclude problematic columns like `Type`
- **Deployment Packages**: Complete Bicep templates with parameters and deployment scripts

## Key Features
- ✅ **Type Column Filtering**: Removes reserved `Type` column that causes DCR failures
- ✅ **Correct Transform Functions**: `toguid(TenantId)`, `toreal(Double_d)` based on JSON types
- ✅ **JSON-Compatible Input**: String/dynamic input types with KQL conversions
- ✅ **Complete Packages**: Bicep template + parameters + deployment script per table
- ✅ **Production Ready**: Role assignments, proper output streams, validated schemas

## Configuration Settings

### Input/Output Directories
```powershell
$jsonExportDirectory = Join-Path $PSScriptRoot "json-exports"    # Input JSON files
$outputDirectory = $PSScriptRoot                                 # Base output directory  
$dcrDirectory = Join-Path $outputDirectory "dcr-from-json"      # DCR output directory
```

### Bicep Template Configuration
```powershell
$bicepConfig = @{
    DefaultLocation = "Australia East"                           # Azure region
    DefaultWorkspaceName = "sentinel-workspace"                 # Workspace name
    RoleDefinitionId = "3913510d-42f4-4e42-8a64-420c390055eb"  # Monitoring Metrics Publisher
}
```

### Processing Settings
```powershell
$ErrorActionPreference = "Stop"                                 # Strict error handling
```

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
│   └── deploy-TableName_CL.ps1          # PowerShell deployment script
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
          // Type column automatically filtered out
        ]
      }
    }
    // ... rest of DCR configuration
  }
}
```

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

### PowerShell Deployment Script
```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "dcr-GCP_DNS_CL.parameters.json"
)

$deploymentName = "dcr-GCP_DNS_CL-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -Name $deploymentName `
    -TemplateFile "dcr-GCP_DNS_CL.bicep" `
    -TemplateParameterFile $ParametersFile `
    -Verbose
```

## Reserved Column Filtering

### Automatically Removed Columns
- **Type**: Confirmed reserved for DCRs - causes deployment failures
- **System columns** (starting with `_`): Filtered out for DCR compatibility

### Filtering Logic
```powershell
$dcrReservedColumns = @(
    'Type'  # Confirmed reserved for DCRs - deployment fails with this column
)

$filteredColumns = $columns | Where-Object { 
    $_.name -notin $dcrReservedColumns -and -not $_.name.StartsWith("_")
}
```

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
| JSON Type | Transform Function | Target Type |
|-----------|-------------------|-------------|
| `String` | `tostring()` | String |
| `DateTime` | `todatetime()` | DateTime |
| `Guid` | `toguid()` | Guid |
| `Double` | `toreal()` | Real |
| `Int` | `toint()` | Int |
| `Long` | `tolong()` | Long |
| `Boolean` | `tobool()` | Boolean |
| `Dynamic` | `todynamic()` | Dynamic |

## Prerequisites

### Required Files
- **Input**: JSON schema files in `json-exports\` directory
- **Module**: `LogAnalyticsCommon.psm1` in same directory

### JSON Schema Source
Run this first to generate input files:
```powershell
.\log-analytics-schema-export.ps1
```

Optionally run cleanup:
```powershell
.\json-schema-cleanup.ps1
```

## Usage Examples

### Generate DCRs for All JSON Files
```powershell
# Ensure JSON files exist
.\log-analytics-schema-export.ps1

# Generate DCRs
.\json-to-bicep-dcr-export.ps1
```

### Deploy Generated DCR
```powershell
# Navigate to table directory
cd dcr-from-json\GCP_DNS_CL

# Update parameters file with real values
# Edit dcr-GCP_DNS_CL.parameters.json

# Deploy using generated script
.\deploy-GCP_DNS_CL.ps1 -ResourceGroupName "my-resource-group"
```

### Manual Bicep Deployment
```powershell
# Using Azure CLI
az deployment group create `
  --resource-group "my-resource-group" `
  --template-file "dcr-GCP_DNS_CL.bicep" `
  --parameters "@dcr-GCP_DNS_CL.parameters.json"
```

## Integration Workflow

### Complete DCR Creation Process
```
1. log-analytics-schema-export.ps1  →  JSON schemas
2. json-schema-cleanup.ps1 (optional)  →  Cleaned schemas  
3. json-to-bicep-dcr-export.ps1  →  DCR Bicep templates
4. Deploy DCRs  →  Production data collection
```

### Parameter Configuration
Before deployment, update parameter files with:
- **Data Collection Endpoint ID**: Your DCE resource ID
- **Workspace Resource ID**: Target Log Analytics workspace
- **Service Principal Object ID**: For DCR permissions
- **Resource Group**: Target deployment resource group

## Console Output

### Processing Status
```
Processing: GCP_DNS_CL
    Filtered out 1 reserved/system columns for DCR:
      - Type (reserved for DCR)
    Generating DCR schema (JSON input types only)...
      TenantId: string -> Guid (via TenantId = toguid(TenantId))
      payload_vmInstanceId_d: string -> Double (via payload_vmInstanceId_d = toreal(payload_vmInstanceId_d))
    Output stream: Custom-GCP_DNS_CL (custom table as specified)
  SUCCESS: 45 total columns -> 44 DCR columns
    Output Stream: Custom-GCP_DNS_CL
    Files: dcr-from-json\GCP_DNS_CL
```

### Export Summary
```
Export Summary:
===============
SUCCESS: 25/25 JSON files processed
FAILED: 0/25 JSON files failed

Successful Exports:
  * GCP_DNS_CL: 44 DCR columns (Custom) -> Custom-GCP_DNS_CL
  * ZeroFoxAlertPoller_CL: 50 DCR columns (Custom) -> Custom-ZeroFoxAlertPoller_CL
```

## Troubleshooting

### Common Issues
- **JSON files not found**: Run `log-analytics-schema-export.ps1` first
- **Type column errors**: Script automatically filters this out  
- **Transform failures**: Check JSON schema has correct data types
- **Deployment failures**: Verify parameter file values

### Error Resolution
- **Invalid transform output**: Re-run with corrected JSON schemas
- **Reserved column errors**: Check filtering is working correctly
- **Permission denied**: Verify service principal has correct roles
- **Template validation errors**: Check Bicep syntax in generated files

## Advanced Configuration

### Custom Output Location
```powershell
$dcrDirectory = "C:\MyDCRs"
```

### Custom Bicep Configuration
```powershell
$bicepConfig = @{
    DefaultLocation = "East US"
    DefaultWorkspaceName = "my-workspace"  
    RoleDefinitionId = "custom-role-id"
}
```

### Deployment Customization
Edit generated parameter files for:
- Different Azure regions
- Custom workspace names  
- Specific service principals
- Custom resource naming

This script provides production-ready DCR deployment packages with empirically validated configurations that avoid common deployment pitfalls.
