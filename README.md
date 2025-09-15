# PowerShell Kusto Schema Tools

<p align="center">
  <img src="https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge&logo=powershell" alt="PowerShell Version"/>
  <img src="https://img.shields.io/badge/Azure-Data%20Platform-0078d4?style=for-the-badge&logo=microsoftazure" alt="Azure Platform"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License"/>
  <img src="https://img.shields.io/badge/Enterprise-Ready-orange?style=for-the-badge" alt="Enterprise Ready"/>
</p>

---

The tools in this repository are written to assist engineers with the fundamental data interchange problems when trying to managed data seamlessly between Azure Data Explorer (ADX) and Microsoft Sentinel. 

The scripts and example output in this archive will be of help if you are tasked with:

* Recreating Sentinel and Log Analytics tables in Azure Data Explorer (ADX) and Eventhouse

* Creating Data Collection Rules to write to Log Analytics / Sentinel

* Extending Log Analytics to supportnew Custom Log (_CL_) tables.

* Exporting custom tables from Azure Data Explorer for use in Log Analytics

* Maintaining a dedicated, maximum security Kusto powered Big Data Cluster for all your Technology environment needs. 

---

## 💎 **Enterprise Assets Included**

- **400+ Production DCR Templates**: Bicep deployment packages for _CL definitions for most major security vendors
- **400+ Bicep Table Definitions**: Infrastructure-as-code examples for extending Log Analytics custom tables  
- **1000+ KQL Table Definitions**: KQL schema templates derived from Log Analytics and the Sentinel archive to serve as templates fore data engineering.  
- **Hybrid Schema Discovery**: Combines Management API with runtime getschema queries for complete coverage
- **PowerShell scripts**: The raw scripts for exporting schema and creatting Data Collection Rules when required.

---

## 🏗️ **Schema-as-Code Pipeline**

```
Data Source Schema → Standardised JSON → Multiple Deployment Targets
                                    ↓
            ┌─────────────────────────────────────────────────────┐
            ↓                     ↓                             ↓
    Azure Data Explorer      Data Collection Rules      Log Analytics Tables
    (KQL Deployments)       (Bicep Templates)         (Bicep Definitions)
```

Simple JSON schema files are used for generating a complete Repo of artifacts for use with CI/CD pipelines.  These artifacts automate much of the frustrating work around Kusto schema and Data Collection Rule creation.

---

## 📂 **Repository Structure**

### Schema Export & Discovery

- **`adx-to-json-export.ps1`** - Extract schemas from Azure Data Explorer clusters
- **`log-analytics-to-json-export.ps1`** - Comprehensive Log Analytics workspace schema export
- **`LogAnalyticsCommon.psm1`** - Core module with empirical Microsoft API bug fixes

### Infrastructure-as-Code Generation

- **`json-to-bicep-dcr-export.ps1`** - Generate DCR templates with correct output stream logic
- **`json-to-bicep-table-export.ps1`** - Create Log Analytics table definitions with dataTypeHint optimization
- **`json-to-adx-kql-export.ps1`** - ADX table creation with ingestion mapping automation

### Direct Export Workflows

- **`log-analytics-to-adx-kql-export.ps1`** - Direct cross-platform schema migration  
- **`log-analytics-to-bicep-dcr-export.ps1`** - Production DCR generation from live schemas

---

## 📁 **Production Example Archives**

This repository contains the **largest known collection** of production-ready Data Collection Rules and Bicep table definitions for enterprise security platforms.

| Directory                                         | Contents                           | Count    | Description                                                                                                                                                  |
| ------------------------------------------------- | ---------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [`bicep-tables/`](bicep-tables)                   | **Bicep Table Definitions**        | 400+     | Complete Log Analytics custom table definitions with deployment automation for major security vendors (Corelight, CrowdStrike, SentinelOne, Palo Alto, etc.) |
| [`dcr-from-json/`](dcr-from-json)                 | **Data Collection Rule Templates** | 400+     | Production-ready DCR Bicep templates with parameters files and PowerShell deployment scripts for enterprise security data sources                            |
| [`kql-from-loganalytics/`](kql-from-loganalytics) | **KQL Table Creation Scripts**     | 1000+    | Complete KQL table definitions extracted from Log Analytics for ADX deployment, covering Microsoft native and custom security tables                         |
| [`kql-from-json/`](kql-from-json)                 | **Generated KQL Scripts**          | Variable | KQL table definitions generated from JSON schema exports with ingestion mappings and update policies                                                         |
| [`json-exports/`](json-exports)                   | **JSON Schema Files**              | Variable | Standardized JSON schema exports from Log Analytics workspaces for cross-platform schema management                                                          |
| [`docs/`](docs)                                   | **Technical Documentation**        | 8 files  | Comprehensive implementation guides for all scripts and deployment patterns                                                                                  |

---

## 📚 **Documentation**

- **[Complete Technical Documentation](docs/README.md)** - Detailed usage for all tools

---

## 📄 **License & Support**

- **License**: Shared under MIT License.
