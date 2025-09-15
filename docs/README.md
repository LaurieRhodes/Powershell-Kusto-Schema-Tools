# PowerShell Kusto Schema Tools - Documentation

Documentation for the schema interchange tools. Each script has detailed configuration and usage instructions.

## Documentation Files

### Schema Export Scripts

- **[adx-to-json-export.md](adx-to-json-export.md)** - Export ADX table schemas to JSON
- **[log-analytics-to-json-export.md](log-analytics-to-json-export.md)** - Export Log Analytics schemas to JSON  
- **[log-analytics-to-adx-kql-export.md](log-analytics-to-adx-kql-export.md)** - Direct LA to ADX KQL export

### JSON Transform Scripts

- **[json-to-adx-kql-export.md](json-to-adx-kql-export.md)** - JSON to ADX KQL scripts
- **[json-to-bicep-dcr-export.md](json-to-bicep-dcr-export.md)** - JSON to Bicep DCR templates
- **[json-to-bicep-table-export.md](json-to-bicep-table-export.md)** - JSON to Bicep table definitions

### Direct Export Scripts

- **[log-analytics-to-bicep-dcr-export.md](log-analytics-to-bicep-dcr-export.md)** - Direct LA to Bicep DCR export

### Support Module

- **[LogAnalyticsCommon.md](LogAnalyticsCommon.md)** - Shared functions and API fixes

## Workflow Patterns

### JSON-Based (Maximum Flexibility)

```
Source → JSON Export → Transform Scripts → Deploy
```

**ADX to Multiple Targets:**

```
adx-to-json-export.ps1 → JSON files → json-to-* scripts
```

**Log Analytics to Multiple Targets:**

```
log-analytics-to-json-export.ps1 → JSON files → json-to-* scripts
```

### Direct Export (Simple Migration)

```
Source → Direct Script → Deploy
```

**Log Analytics Direct:**

```
log-analytics-to-adx-kql-export.ps1
log-analytics-to-bicep-dcr-export.ps1
```

## Script Selection

| Source        | Target    | Use                                     |
| ------------- | --------- | --------------------------------------- |
| ADX           | JSON      | `adx-to-json-export.ps1`                |
| Log Analytics | JSON      | `log-analytics-to-json-export.ps1`      |
| JSON          | ADX       | `json-to-adx-kql-export.ps1`            |
| JSON          | DCR       | `json-to-bicep-dcr-export.ps1`          |
| JSON          | LA Tables | `json-to-bicep-table-export.ps1`        |
| Log Analytics | ADX       | `log-analytics-to-adx-kql-export.ps1`   |
| Log Analytics | DCR       | `log-analytics-to-bicep-dcr-export.ps1` |

## Configuration Patterns

### All Tables Export

```powershell
$ExportAll = $true
$FilterUnderscoreTables = $false     # Include system tables
$useHybridDiscovery = $true         # Full coverage
```

### Targeted Export

```powershell
$ExportAll = $false
$tablesToExport = @('SecurityEvent', 'Syslog', 'CommonSecurityLog')
$FilterUnderscoreTables = $true     # Exclude system tables
```

### Performance Mode

```powershell
$ExportAll = $false                 # Specific tables only
$useHybridDiscovery = $false        # Management API only
$FilterUnderscoreTables = $true     # Reduce overhead
```

## Common Variables

All scripts use these standard configuration variables:

```powershell
# Azure Environment
$workspaceName = 'YOUR-WORKSPACE-NAME'
$resourceGroupName = 'YOUR-RESOURCE-GROUP-NAME'  
$subscriptionId = 'YOUR-SUBSCRIPTION-ID'

# ADX Environment (ADX scripts only)
$adxClusterUri = "https://YOUR-CLUSTER-NAME.YOUR-REGION.kusto.windows.net"
$adxDatabase = "YOUR-DATABASE-NAME"

# Processing Options
$ExportAll = $true/$false
$FilterUnderscoreTables = $true/$false
$useHybridDiscovery = $true/$false
```

## Prerequisites

All scripts require:

- PowerShell 5.1+
- Az.Accounts module
- Az.OperationalInsights module  
- Azure authentication: `Connect-AzAccount`

ADX scripts additionally require:

- Read access to ADX cluster
- LogAnalyticsCommon.psm1 module

## Troubleshooting

**"Configuration values cannot be empty"**

- Update placeholder values with your environment details

**Authentication failures**  

- Run `Connect-AzAccount`
- Verify workspace/cluster access permissions

**"No tables found"**

- Check workspace/database names
- Verify FilterUnderscoreTables setting if expecting system tables

**API rate limiting**

- Scripts include built-in retry logic
- Large workspaces may take several minutes

## Output Structure

Scripts create these directories:

- `json-exports/` - JSON schema files from Log Analytics
- `json-exports-from-adx/` - JSON schema files from ADX
- `kql-from-json/` - Generated KQL scripts  
- `kql-complete/` - Direct KQL exports
- `dcr-from-json/` - Generated DCR templates
- `dcr/` - Direct DCR exports
- `bicep-tables-from-json/` - Generated table definitions

Each contains ready-to-deploy artifacts with deployment scripts.
