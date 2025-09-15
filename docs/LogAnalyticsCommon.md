# LogAnalyticsCommon.psm1

## Overview
Shared PowerShell module containing common functions for Log Analytics schema discovery, data type corrections, and Azure authentication. This module provides the core functionality used by all other scripts in the PowerShell Kusto Schema Tools toolkit.

## Purpose
- **Centralized Functions**: Common functionality shared across all toolkit scripts
- **Azure Authentication**: Future-compatible token management for Azure APIs
- **Schema Discovery**: Hybrid approach using Management API + getschema queries
- **Data Type Corrections**: Empirical fixes for Microsoft API bugs
- **Type Conversions**: Mappings between Log Analytics, ADX, and DCR types

## Key Features
- ✅ **Future-Compatible Authentication**: Handles both current and future Az.Accounts versions
- ✅ **Hybrid Schema Discovery**: Combines Management API and getschema for complete coverage
- ✅ **Empirical Bug Fixes**: Built-in corrections for known Microsoft API issues
- ✅ **Type System Mappings**: Conversions for Log Analytics → ADX → DCR workflows
- ✅ **Error Handling**: Robust error handling with detailed reporting

## Authentication Functions

### Get-SafeAccessToken
```powershell
Get-SafeAccessToken -ResourceUrl "https://management.azure.com/"
```
**Purpose**: Gets Azure access token with future-compatible handling
**Parameters**: 
- `ResourceUrl`: The Azure resource URL to get token for

**Features**:
- **Future-proof**: Handles both current and future Az.Accounts versions
- **Automatic fallback**: Tries AsSecureString parameter, falls back to current behavior
- **Token conversion**: Converts SecureString to plain text for API calls

**Usage in Scripts**:
```powershell
$managementToken = Get-SafeAccessToken -ResourceUrl "https://management.azure.com/"
$laToken = Get-SafeAccessToken -ResourceUrl "https://api.loganalytics.io/"
```

## Schema Discovery Functions

### Get-ManagementAPIColumns
```powershell
Get-ManagementAPIColumns -tableName "CommonSecurityLog" -authHeaders $headers -subscriptionId $subId -resourceGroupName $rgName -workspaceName $wsName
```
**Purpose**: Gets table columns from Azure Management API
**Returns**: Column definitions with source = "ManagementAPI"

**Features**:
- **Complete schema**: Gets both standard and custom columns
- **Table type detection**: Returns table type (CustomLog, Microsoft, etc.)
- **Error handling**: Graceful failure with detailed error messages

### Get-GetSchemaColumns
```powershell
Get-GetSchemaColumns -tableName "CommonSecurityLog" -workspaceGuid $guid -queryHeaders $headers
```
**Purpose**: Gets table columns using KQL getschema query
**Returns**: Column definitions with source = "GetSchema"

**Features**:
- **Runtime discovery**: Finds columns that may not be in Management API
- **Type inference**: Applies empirical corrections for well-known GUID fields
- **Additional columns**: Discovers columns missed by Management API

### Merge-ColumnSources
```powershell
Merge-ColumnSources -managementColumns $mgmtCols -getSchemaColumns $schemaCols -preferManagementTypes $true
```
**Purpose**: Combines column information from both sources
**Returns**: Merged column set with additional count

**Features**:
- **Smart merging**: Management API takes precedence for type definitions
- **Additional discovery**: Reports how many extra columns were found
- **Conflict resolution**: Consistent handling of overlapping columns

## Data Type Correction Functions

### Infer-DataTypeFromName
```powershell
Infer-DataTypeFromName -columnName "TenantId" -getSchemaType "string"
```
**Purpose**: Corrects well-known GUID fields that may be reported as string

**Corrections Applied**:
- **TenantId**: `string` → `guid`
- **WorkspaceId**: `string` → `guid`

**Conservative Approach**: Only corrects well-known system fields

## Type Conversion Functions

### Convert-LATypeToADXType
```powershell
Convert-LATypeToADXType -laType "guid"
```
**Purpose**: Converts Log Analytics data type to Azure Data Explorer type

**Mappings**:
```powershell
'string' → 'string'
'datetime' → 'datetime' 
'guid' → 'guid'
'real' → 'real'
'int' → 'int'
'long' → 'long'
'bool' → 'bool'
'dynamic' → 'dynamic'
'timespan' → 'timespan'
```

### Get-ADXConversionFunction
```powershell
Get-ADXConversionFunction -laType "guid"
```
**Purpose**: Gets ADX conversion function for Log Analytics type

**Returns**: KQL conversion functions
```powershell
'string' → 'tostring'
'datetime' → 'todatetime'
'guid' → 'toguid'
'real' → 'toreal'
'int' → 'toint'
'long' → 'tolong'
'bool' → 'tobool'
'dynamic' → 'todynamic'
'timespan' → 'totimespan'
```

### ConvertTo-DCRInputType
```powershell
ConvertTo-DCRInputType -logAnalyticsType "guid"
```
**Purpose**: Converts Log Analytics type to DCR input stream type (JSON-compatible only)

**Features**:
- **JSON compatibility**: DCRs can only handle string, int, and dynamic input types
- **Resilient design**: Accepts most types as strings to handle operator errors
- **Transform-based**: All other types converted in transform KQL

**Mappings**:
```powershell
"string" → "string"
"dynamic" → "dynamic"
"guid" → "string"      # Will use toguid() in transform
"datetime" → "string"  # Will use todatetime() in transform
"real" → "string"      # Will use toreal() in transform
"int" → "string"       # Resilience against "123" vs 123
```

### Get-DCRTransformFunction
```powershell
Get-DCRTransformFunction -columnName "TenantId" -inputType "string" -outputType "guid"
```
**Purpose**: Gets KQL conversion function for DCR transform with defensive casting

**Returns**: Proper KQL assignment format
```powershell
"TenantId = toguid(TenantId)"
"payload_count_d = toreal(payload_count_d)"
"TimeGenerated = todatetime(TimeGenerated)"
```

**Features**:
- **Defensive casting**: Always casts to target type for consistency
- **Proper format**: Returns complete KQL assignment statements
- **Error resilience**: Handles type conversion failures gracefully

### Get-DCROutputStreamName
```powershell
Get-DCROutputStreamName -tableName "CommonSecurityLog" -tableType "Microsoft"
```
**Purpose**: Gets correct DCR output stream name based on table type

**Logic**:
- **CustomLog**: Always uses `Custom-` prefix
- **Microsoft**: Uses `Microsoft-` for known writable tables, `Custom-` for others
- **SearchResults**: Uses `Custom-` prefix
- **Unknown**: Defaults to `Custom-` (safer for DCR ingestion)

**Known Writable Microsoft Tables**:
```powershell
'CommonSecurityLog'
'Syslog'
'SecurityEvent'
'WindowsEvent'
```

## Utility Functions

### Filter-NonUnderscoreColumns
```powershell
Filter-NonUnderscoreColumns -columns $columns
```
**Purpose**: Filters out columns that start with underscore for DCR processing

**Features**:
- **System column removal**: Excludes `_ResourceId`, `_BilledSize`, etc.
- **Exception handling**: Keeps `_TimeReceived` if present (custom addition)
- **Detailed reporting**: Shows what was filtered and why

### Test-PrerequisitesAndAuth
```powershell
Test-PrerequisitesAndAuth -subscriptionId $subId -tenantId $tenantId
```
**Purpose**: Tests prerequisites and handles Azure authentication

**Features**:
- **Module validation**: Checks for required Az modules
- **Automatic import**: Imports modules if not already loaded
- **Authentication handling**: Connects to Azure if not authenticated
- **Context management**: Sets correct subscription context

**Required Modules**:
- `Az.Accounts`
- `Az.OperationalInsights`

## Exported Functions
The module exports all major functions for use by other scripts:

```powershell
Export-ModuleMember -Function @(
    'Get-SafeAccessToken',
    'Get-ManagementAPIColumns',
    'Get-GetSchemaColumns', 
    'Infer-DataTypeFromName',
    'Merge-ColumnSources',
    'Convert-LATypeToADXType',
    'Get-ADXConversionFunction',
    'ConvertTo-DCRInputType',
    'Get-DCRTransformFunction',
    'Get-DCROutputStreamName',
    'ConvertTo-DCRType',
    'Filter-NonUnderscoreColumns',
    'Test-PrerequisitesAndAuth'
)
```

## Usage in Scripts

### Import Module
```powershell
$modulePath = Join-Path $PSScriptRoot "LogAnalyticsCommon.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
} else {
    throw "ERROR: LogAnalyticsCommon.psm1 module not found"
}
```

### Authentication Pattern
```powershell
# Test prerequisites and authenticate
$context = Test-PrerequisitesAndAuth -subscriptionId $subscriptionId -tenantId $tenantId

# Get tokens
$managementToken = Get-SafeAccessToken -ResourceUrl "https://management.azure.com/"
$laToken = Get-SafeAccessToken -ResourceUrl "https://api.loganalytics.io/"
```

### Schema Discovery Pattern
```powershell
# Get from Management API
$mgmtResult = Get-ManagementAPIColumns -tableName $tableName -authHeaders $headers ...

# Get additional from getschema
$schemaResult = Get-GetSchemaColumns -tableName $tableName -workspaceGuid $guid ...

# Merge sources
$mergeResult = Merge-ColumnSources -managementColumns $mgmtResult.columns -getSchemaColumns $schemaResult.columns
$finalColumns = $mergeResult.columns
```

### Type Conversion Pattern
```powershell
# For ADX conversion
foreach ($column in $columns) {
    $adxType = Convert-LATypeToADXType -laType $column.type
    $conversionFunc = Get-ADXConversionFunction -laType $column.type
}

# For DCR conversion
foreach ($column in $columns) {
    $inputType = ConvertTo-DCRInputType -logAnalyticsType $column.type
    $transformFunc = Get-DCRTransformFunction -columnName $column.name -inputType $inputType -outputType $column.type
}
```

## Error Handling

### Graceful Failures
All functions include comprehensive error handling:
- **Try-catch blocks**: Wrap API calls and complex operations
- **Detailed error messages**: Include context about what failed
- **Fallback behavior**: Continue processing when possible
- **Status reporting**: Clear success/failure indicators

### Logging Pattern
```powershell
try {
    # Operation
    Write-Host "SUCCESS: Operation completed" -ForegroundColor Green
    return @{ success = $true; data = $result }
} catch {
    Write-Host "ERROR: Operation failed - $($_.Exception.Message)" -ForegroundColor Red
    return @{ success = $false; error = $_.Exception.Message }
}
```

## Integration Benefits

### Consistency Across Scripts
- **Same authentication**: All scripts use identical token management
- **Same discovery**: All scripts use identical schema discovery logic
- **Same corrections**: All scripts apply identical empirical fixes
- **Same type mappings**: All scripts use identical conversion logic

### Maintainability
- **Single source of truth**: Bug fixes apply to all scripts
- **Version compatibility**: Future Az.Accounts changes handled in one place
- **API changes**: Management API changes addressed centrally
- **Type system updates**: New type mappings added once

### Error Reduction
- **Tested functions**: All functions validated through empirical deployment testing
- **Consistent behavior**: Same logic reduces script-specific bugs
- **Centralized validation**: Input validation handled consistently

This module forms the foundation of the entire PowerShell Kusto Schema Tools toolkit, ensuring consistent, reliable, and future-compatible functionality across all schema management operations.
