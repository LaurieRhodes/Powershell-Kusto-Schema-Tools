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

### Log Analytics Writeable Table validation

- **[bulk-dcr-deployment-test.md](bulk-dcr-deployment-test.md)** - Test what Log Analytics tables may be written to

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

## Prerequisites

All scripts require:

- PowerShell 5.1+
- Az.Accounts module
- Az.OperationalInsights module  
- Azure authentication: `Connect-AzAccount`

ADX scripts additionally require:

- Read access to ADX cluster
- LogAnalyticsCommon.psm1 module
