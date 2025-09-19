## Log-Analytics-to-Bicep-DCR-export.ps1

## Overview

Generates Data Collection Rule (DCR) Bicep templates from Log Analytics table schemas with simplified export configuration options.

## Purpose

- **DCR Automation**: Generate complete DCR deployments from corrected JSON schemas
- **Transform Generation**: Create proper KQL transform functions with correct type conversions
- **Reserved Column Filtering**: Automatically exclude illegal columns like `Type`
- **Deployment Packages**: Complete Bicep templates with parameters and deployment scripts
- **Flexible Export Control**: Export all workspace tables or specific tables

## Configuration Settings

### Azure Environment

```powershell
# UPDATE THESE VALUES FOR YOUR ENVIRONMENT
$workspaceName = 'YOUR-WORKSPACE-NAME'
$resourceGroupName = 'YOUR-RESOURCE-GROUP-NAME'
$subscriptionId = 'YOUR-SUBSCRIPTION-ID'
$tenantId = ''  # Optional - leave empty to use current context
```

Configure script parameters for the Log Analytics environment you wish to export.

### Export Configuration

```powershell
# Export Configuration
$ExportAll = $true                    # Set to $true to export ALL workspace tables
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

### Table Selection (Specific Tables Mode)

```powershell
# Specific tables to export (ignored if ExportAll is $true)
$tablesToExport = @(
    'Anomalies',
    'ASimAuditEventLogs',
    'ASimAuthenticationEventLogs',
    'ASimDhcpEventLogs',
    'ASimDnsActivityLogs',
    'ASimFileEventLogs',
    'ASimNetworkSessionLogs',
    'ASimProcessEventLogs',
    'ASimRegistryEventLogs',
    'ASimUserManagementActivityLogs',
    'ASimWebSessionLogs',
    'AWSCloudTrail',
    'AWSCloudWatch',
    'AWSGuardDuty',
    'AWSVPCFlow',
    'CommonSecurityLog',    
    'GCPAuditLogs',
    'GoogleCloudSCC',
    'SecurityEvent',
    'Syslog'
)
```

### Output Configuration

```powershell
$outputDirectory = $PSScriptRoot
$dcrDirectory = Join-Path $outputDirectory "dcr-from-log-analytics"
```

The produced output of this script will be in a subdirectory off the root of the script directory.

### Bicep Template Configuration

```powershell
$bicepConfig = @{
    DefaultLocation = "Australia East"
    DefaultWorkspaceName = "sentinel-workspace"
    RoleDefinitionId = "3913510d-42f4-4e42-8a64-420c390055eb" # Monitoring Metrics Publisher
}
```

Example Bicep parameter file constructure may be defined within the script.  Note that the DefaultWorkspaceName parameter is used as part of a friendly name with the DCR created.

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
          // Type column: always filtered out (DCR reserved)
        ]
      }
    }
    // ... rest of DCR configuration
  }
}
```

Notice that the stream declaration is always a 'Custom' stream.  The primary output is a Data Collection Rule in Bicep.

#### 2. Transform KQL Generation

```bicep
transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), payload_vmInstanceId_d = toreal(payload_vmInstanceId_d)'
```

The creation of Transform KQL statements is a huge labour saving advantage of generating Data Collection Rules by script.

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

Tempates include permission assignments for writing to the DCR

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

## Column Filtering

### Always Filtered Columns

- **Type**: Microsoft reserved column - **always** filtered out regardless of settings (causes DCR deployment failures)
- **Underscore columns**: Microsoft reserved column - **always** filtered out regardless of settings (causes DCR deployment failures)

This filtering ensures that:

- DCR deployment succeeds by removing reserved columns
- Column schemas are compatible with DCR requirements

## Configuration Summary

| Setting               | Purpose                 | Default         | Impact                                    |
| --------------------- | ----------------------- | --------------- | ----------------------------------------- |
| `$ExportAll`          | Export mode selection   | `$true`         | When true, discovers all workspace tables |
| `$tablesToExport`     | Specific table list     | Predefined list | Used only when `$ExportAll = $false`      |
| `$useHybridDiscovery` | Schema discovery method | `$true`         | Uses both Management API and getschema    |

## Prerequisites

### Azure Environment

- **Log Analytics workspace**: Source of schema information
- **Data Collection Endpoint**: Target for DCR deployment
- **Service Principal**: For DCR access permissions
- **Azure PowerShell**: `Az.Accounts`, `Az.OperationalInsights` modules

### Permissions Required

- **Log Analytics**: Reader access to workspace
- **Resource Group**: Contributor access for DCR deployment
- **Subscription**: Reader access for resource ID construction

### Dependencies

- **Module**: `LogAnalyticsCommon.psm1` in same directory
- **Authentication**: Valid Azure authentication context

## Output Structure

The script creates a directory structure under `dcr/` with one subdirectory per table:

```
dcr/
├── SecurityEvent/
│   ├── dcr-SecurityEvent.bicep
│   ├── dcr-SecurityEvent.parameters.json
│   └── deploy-SecurityEvent.ps1
├── CommonSecurityLog/
│   ├── dcr-CommonSecurityLog.bicep
│   ├── dcr-CommonSecurityLog.parameters.json
│   └── deploy-CommonSecurityLog.ps1
└── ...
```

Each directory contains:

- **Bicep template**: Complete DCR resource definition
- **Parameters file**: Deployment parameter template
- **PowerShell script**: Deployment automation script

# 