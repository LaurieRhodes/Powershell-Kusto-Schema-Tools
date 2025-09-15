# ============================================================================
# Log Analytics Common Functions Module
# ============================================================================
# Shared functions for Log Analytics schema discovery and processing
# Used by both KQL export and DCR export scripts
# ============================================================================

# Error handling
$ErrorActionPreference = "Stop"

# ============================================================================
# TOKEN MANAGEMENT FUNCTIONS
# ============================================================================

function Get-SafeAccessToken {
    <#
    .SYNOPSIS
    Gets Azure access token with future-compatible handling
    
    .DESCRIPTION
    Handles both current and future Az.Accounts versions for token retrieval
    
    .PARAMETER ResourceUrl
    The Azure resource URL to get token for
    #>
    param([string]$ResourceUrl)
    
    # Handle both current and future Az.Accounts versions
    try {
        # Try the future-compatible approach first
        $tokenResult = Get-AzAccessToken -ResourceUrl $ResourceUrl -AsSecureString -ErrorAction SilentlyContinue
        if ($tokenResult) {
            # Convert SecureString to plain text for API calls
            $plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokenResult.Token))
            return $plainToken
        }
    } catch {
        # AsSecureString parameter doesn't exist in current version, fall back
    }
    
    # Fall back to current behavior (will work until Az 14.0.0)
    $tokenResult = Get-AzAccessToken -ResourceUrl $ResourceUrl
    return $tokenResult.Token
}

# ============================================================================
# SCHEMA DISCOVERY FUNCTIONS
# ============================================================================

function Get-ManagementAPIColumns {
    <#
    .SYNOPSIS
    Gets table columns from Azure Management API
    
    .DESCRIPTION
    Retrieves table schema information from Azure Management API
    
    .PARAMETER tableName
    Name of the table to get schema for
    
    .PARAMETER authHeaders
    Authentication headers for API calls
    
    .PARAMETER subscriptionId
    Azure subscription ID
    
    .PARAMETER resourceGroupName
    Resource group name
    
    .PARAMETER workspaceName
    Log Analytics workspace name
    #>
    param(
        [string]$tableName, 
        [hashtable]$authHeaders, 
        [string]$subscriptionId, 
        [string]$resourceGroupName, 
        [string]$workspaceName
    )
    
    try {
        Write-Host "    Getting columns from Management API..." -ForegroundColor Gray
        $apiUri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName/providers/microsoft.operationalinsights/workspaces/$workspaceName/tables/$tableName" + "?api-version=2023-09-01"
        $response = Invoke-RestMethod -Method Get -Headers $authHeaders -Uri $apiUri -UseBasicParsing
        
        $columnDefinitions = @()
        $tableType = "Unknown"
        if ($response.properties.schema.tableType) {
            $tableType = $response.properties.schema.tableType
        }
        
        if ($response.properties.schema.columns -and $tableType -eq "CustomLog") {
            foreach ($column in $response.properties.schema.columns) {
                $columnDefinitions += @{ name = $column.name; type = $column.type; description = $column.description; source = "ManagementAPI" }
            }
        } else {
            if ($response.properties.schema.standardColumns) {
                foreach ($column in $response.properties.schema.standardColumns) {
                    $columnDefinitions += @{ name = $column.name; type = $column.type; description = $column.description; source = "ManagementAPI" }
                }
            }
            if ($response.properties.schema.customColumns) {
                foreach ($column in $response.properties.schema.customColumns) {
                    $columnDefinitions += @{ name = $column.name; type = $column.type; description = $column.description; source = "ManagementAPI" }
                }
            }
        }
        
        Write-Host "    Management API: Found $($columnDefinitions.Count) columns" -ForegroundColor Gray
        return @{ columns = $columnDefinitions; tableType = $tableType; success = $true }
    } catch {
        Write-Host "    Management API: ERROR - $($_.Exception.Message)" -ForegroundColor Yellow
        return @{ columns = @(); tableType = "Unknown"; success = $false; error = $_.Exception.Message }
    }
}

function Get-GetSchemaColumns {
    <#
    .SYNOPSIS
    Gets table columns using KQL getschema query
    
    .DESCRIPTION
    Retrieves table schema information using Log Analytics KQL getschema query
    
    .PARAMETER tableName
    Name of the table to get schema for
    
    .PARAMETER workspaceGuid
    Log Analytics workspace GUID
    
    .PARAMETER queryHeaders
    Query headers for Log Analytics API
    #>
    param([string]$tableName, [string]$workspaceGuid, [hashtable]$queryHeaders)
    
    try {
        Write-Host "    Getting columns from getschema query..." -ForegroundColor Gray
        $kqlQuery = "$tableName | getschema"
        $encodedQuery = [System.Web.HttpUtility]::UrlEncode($kqlQuery)
        $queryUri = "https://api.loganalytics.io/v1/workspaces/$workspaceGuid/query?query=$encodedQuery"
        $response = Invoke-RestMethod -Method Get -Headers $queryHeaders -Uri $queryUri -UseBasicParsing
        
        $columnDefinitions = @()
        if ($response.tables -and $response.tables[0].rows) {
            foreach ($row in $response.tables[0].rows) {
                $inferredType = Infer-DataTypeFromName -columnName $row[0] -getSchemaType $row[3]
                $columnDefinitions += @{
                    name = $row[0]; type = $inferredType; description = "Discovered via getschema"; source = "GetSchema"
                    ordinal = $row[1]; systemType = $row[2]; originalType = $row[3]
                }
            }
        }
        
        Write-Host "    getschema: Found $($columnDefinitions.Count) columns" -ForegroundColor Gray
        return @{ columns = $columnDefinitions; success = $true }
    } catch {
        Write-Host "    getschema: ERROR - $($_.Exception.Message)" -ForegroundColor Yellow
        return @{ columns = @(); success = $false; error = $_.Exception.Message }
    }
}

function Infer-DataTypeFromName {
    <#
    .SYNOPSIS
    Infers correct data type from column name and getschema type
    
    .DESCRIPTION
    Corrects well-known GUID fields that may be reported as string by getschema
    
    .PARAMETER columnName
    Name of the column
    
    .PARAMETER getSchemaType
    Type reported by getschema
    #>
    param($columnName, $getSchemaType)
    
    # Only correct well-known GUID fields - be conservative
    if (($columnName -eq "TenantId" -or $columnName -eq "WorkspaceId") -and $getSchemaType -eq "string") {
        return "guid"
    }
    return $getSchemaType
}

function Merge-ColumnSources {
    <#
    .SYNOPSIS
    Merges column definitions from Management API and getschema sources
    
    .DESCRIPTION
    Combines column information from both sources, with Management API taking precedence
    
    .PARAMETER managementColumns
    Columns from Management API
    
    .PARAMETER getSchemaColumns
    Columns from getschema query
    
    .PARAMETER preferManagementTypes
    Whether to prefer Management API types over getschema types
    #>
    param([array]$managementColumns, [array]$getSchemaColumns, [bool]$preferManagementTypes = $true)
    
    Write-Host "    Merging column sources..." -ForegroundColor Gray
    $mergedColumns = @()
    $managementColumnNames = $managementColumns | ForEach-Object { $_.name }
    
    foreach ($mgmtCol in $managementColumns) { $mergedColumns += $mgmtCol }
    
    $addedFromGetSchema = 0
    $addedColumns = @()
    foreach ($schemaCol in $getSchemaColumns) {
        if ($schemaCol.name -notin $managementColumnNames) {
            $mergedColumns += $schemaCol
            $addedFromGetSchema++
            $addedColumns += $schemaCol
        }
    }
    
    Write-Host "    Merge result: $($managementColumns.Count) from Management API + $addedFromGetSchema additional from getschema = $($mergedColumns.Count) total" -ForegroundColor Gray
    
    if ($addedFromGetSchema -gt 0) {
        Write-Host "    Additional columns discovered:" -ForegroundColor Cyan
        foreach ($col in $addedColumns) {
            Write-Host "      + $($col.name) ($($col.type))" -ForegroundColor Cyan
        }
    }
    
    return @{
        columns = $mergedColumns
        additionalCount = $addedFromGetSchema
    }
}

# ============================================================================
# TYPE CONVERSION FUNCTIONS
# ============================================================================

function Convert-LATypeToADXType {
    <#
    .SYNOPSIS
    Converts Log Analytics data type to Azure Data Explorer type
    
    .PARAMETER laType
    Log Analytics data type
    #>
    param($laType)
    switch ($laType.ToLower()) {
        'string' { return 'string' }
        'datetime' { return 'datetime' }
        'int' { return 'int' }
        'long' { return 'long' }
        'real' { return 'real' }
        'bool' { return 'bool' }
        'boolean' { return 'bool' }
        'dynamic' { return 'dynamic' }
        'guid' { return 'guid' }
        'timespan' { return 'timespan' }
        default { return 'string' }
    }
}

function Get-ADXConversionFunction {
    <#
    .SYNOPSIS
    Gets ADX conversion function for Log Analytics type
    
    .PARAMETER laType
    Log Analytics data type
    #>
    param($laType)
    switch ($laType.ToLower()) {
        'string' { return 'tostring' }
        'datetime' { return 'todatetime' }
        'int' { return 'toint' }
        'long' { return 'tolong' }
        'real' { return 'toreal' }
        'bool' { return 'tobool' }
        'boolean' { return 'tobool' }
        'dynamic' { return 'todynamic' }
        'guid' { return 'toguid' }
        'timespan' { return 'totimespan' }
        default { return 'tostring' }
    }
}

function ConvertTo-DCRInputType {
    <#
    .SYNOPSIS
    Converts Log Analytics type to DCR input stream type (JSON-compatible only)
    
    .DESCRIPTION
    DCRs receiving JSON can only handle string, int, and dynamic input types.
    All other types must be converted in the transform KQL.
    For resilience, we accept most numeric types as strings to handle operator errors.
    
    .PARAMETER logAnalyticsType
    Log Analytics data type
    #>
    param([string]$logAnalyticsType)
    
    switch ($logAnalyticsType.ToLower()) {
        # Types that can be represented in JSON natively
        "string" { return "string" }
        "dynamic" { return "dynamic" }
        
        # For resilience, accept all numeric types as strings
        # This protects against operators accidentally sending int as "123" instead of 123
        "int" { return "string" }        # Accept as string, cast in transform
        "long" { return "string" }       # Accept as string, cast in transform  
        "real" { return "string" }       # Accept as string, cast in transform
        
        # All other types come in as strings and get converted in transform
        "guid" { return "string" }       # Will be converted with toguid()
        "datetime" { return "string" }   # Will be converted with todatetime()
        "bool" { return "string" }       # Will be converted with tobool()
        "boolean" { return "string" }    # Will be converted with tobool()
        "timespan" { return "string" }   # Will be converted with totimespan()
        
        default { 
            Write-Host "    Unknown type '$logAnalyticsType', defaulting to 'string'" -ForegroundColor Yellow
            return "string" 
        }
    }
}

function Get-DCRTransformFunction {
    <#
    .SYNOPSIS
    Gets the KQL conversion function for DCR transform with defensive casting
    
    .DESCRIPTION
    Always casts to the target type for resilience and consistency.
    Returns proper KQL assignment format: ColumnName = function(ColumnName)
    
    .PARAMETER columnName
    Name of the column
    
    .PARAMETER inputType
    DCR input type (string, int, dynamic)
    
    .PARAMETER outputType
    Final Log Analytics type
    #>
    param([string]$columnName, [string]$inputType, [string]$outputType)
    
    # Always cast to target type for defensive programming and consistency
    # Return proper KQL assignment format: ColumnName = function(ColumnName)
    switch ($outputType.ToLower()) {
        'string' { 
            return "$columnName = tostring($columnName)"
        }
        'datetime' { 
            return "$columnName = todatetime($columnName)" 
        }
        'int' { 
            return "$columnName = toint($columnName)" 
        }
        'long' { 
            return "$columnName = tolong($columnName)" 
        }
        'real' { 
            return "$columnName = toreal($columnName)" 
        }
        'bool' { 
            return "$columnName = tobool($columnName)" 
        }
        'boolean' { 
            return "$columnName = tobool($columnName)" 
        }
        'dynamic' { 
            return "$columnName = todynamic($columnName)" 
        }
        'guid' { 
            return "$columnName = toguid($columnName)" 
        }
        'timespan' { 
            return "$columnName = totimespan($columnName)" 
        }
        default { 
            return "$columnName = tostring($columnName)" 
        }
    }
}

function Get-DCROutputStreamName {
    <#
    .SYNOPSIS
    Gets the correct DCR output stream name based on table type from Management API
    
    .DESCRIPTION
    Uses the tableType from Management API response to accurately determine the correct output stream.
    CustomLog tables always use Custom- prefix.
    Microsoft tables are mostly read-only, with only specific ones being writable via DCR.
    
    .PARAMETER tableName
    Name of the table
    
    .PARAMETER tableType
    Type of table from Management API (CustomLog, Microsoft, SearchResults, etc.)
    #>
    param([string]$tableName, [string]$tableType)
    
    Write-Host "      Table: $tableName, Type: $tableType" -ForegroundColor Gray
    
    # Logic based on Management API tableType response
    switch ($tableType.ToLower()) {
        "customlog" {
            # All custom logs use Custom- prefix (this is definitive from Management API)
            return "Custom-$tableName"
        }
        "microsoft" {
            # Microsoft managed tables - most are read-only, but some specific ones allow DCR writes
            $writableMicrosoftTables = @(
                'CommonSecurityLog',
                'Syslog',
                'SecurityEvent', 
                'WindowsEvent'
                # Add more as Microsoft confirms additional writable tables
            )
            
            if ($tableName -in $writableMicrosoftTables) {
                Write-Host "      Using Microsoft- prefix for known writable table" -ForegroundColor Green
                return "Microsoft-$tableName"
            } else {
                # Most Microsoft tables are read-only, so new data ingestion via DCR uses Custom- 
                Write-Host "      Microsoft table not in known writable list - using Custom- prefix (this is likely correct)" -ForegroundColor Cyan
                return "Custom-$tableName"
            }
        }
        "searchresults" {
            # Search results tables are not writable via DCR
            Write-Host "      Search results table - using Custom- prefix" -ForegroundColor Cyan
            return "Custom-$tableName"
        }
        default {
            # For any unknown types, examine the table name for additional clues
            if ($tableName -match "_CL$") {
                # Ends with _CL, definitely custom
                return "Custom-$tableName"
            } else {
                # Unknown type, default to Custom- (safer for DCR ingestion)
                Write-Host "      Unknown table type '$tableType' - defaulting to Custom- prefix" -ForegroundColor Yellow
                return "Custom-$tableName"
            }
        }
    }
}

function ConvertTo-DCRType {
    <#
    .SYNOPSIS
    Converts Log Analytics type to Data Collection Rule type (DEPRECATED - Use ConvertTo-DCRInputType)
    
    .PARAMETER logAnalyticsType
    Log Analytics data type
    #>
    param([string]$logAnalyticsType)
    
    # This function is deprecated and kept for backward compatibility
    # Use ConvertTo-DCRInputType for proper DCR input type handling
    Write-Warning "ConvertTo-DCRType is deprecated. Use ConvertTo-DCRInputType for DCR input schema."
    
    switch ($logAnalyticsType.ToLower()) {
        "guid" { return "string" }  # DCR doesn't have guid type, use string
        "datetime" { return "datetime" }
        "string" { return "string" }
        "dynamic" { return "dynamic" }
        "real" { return "real" }
        "int" { return "int" }
        "long" { return "long" }
        "bool" { return "boolean" }
        "boolean" { return "boolean" }
        default { 
            Write-Warning "Unknown type '$logAnalyticsType', defaulting to 'string'"
            return "string" 
        }
    }
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

function Filter-NonUnderscoreColumns {
    <#
    .SYNOPSIS
    Filters out columns that start with underscore
    
    .DESCRIPTION
    Removes system columns (starting with _) for DCR processing
    
    .PARAMETER columns
    Array of column definitions
    #>
    param([array]$columns)
    
    # Filter out columns that start with underscore (except _TimeReceived which we add ourselves)
    $filteredColumns = $columns | Where-Object { 
        -not $_.name.StartsWith("_") -or $_.name -eq "_TimeReceived" 
    }
    
    $removedCount = $columns.Count - $filteredColumns.Count
    if ($removedCount -gt 0) {
        Write-Host "    Filtered out $removedCount underscore columns for DCR" -ForegroundColor Yellow
        $removedColumns = $columns | Where-Object { $_.name.StartsWith("_") -and $_.name -ne "_TimeReceived" }
        foreach ($col in $removedColumns) {
            Write-Host "      - $($col.name)" -ForegroundColor Gray
        }
    }
    
    return $filteredColumns
}

function Test-PrerequisitesAndAuth {
    <#
    .SYNOPSIS
    Tests prerequisites and handles Azure authentication
    
    .PARAMETER subscriptionId
    Azure subscription ID
    
    .PARAMETER tenantId
    Azure tenant ID (optional)
    #>
    param([string]$subscriptionId, [string]$tenantId = "")
    
    # Check modules
    $requiredModules = @('Az.Accounts', 'Az.OperationalInsights')
    foreach ($module in $requiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) { 
            throw "ERROR: $module module required. Install with: Install-Module $module" 
        }
        if (-not (Get-Module $module)) { 
            Import-Module $module 
        }
    }
    
    # Handle authentication
    $context = Get-AzContext
    if (-not $context) {
        if ($tenantId) { 
            Connect-AzAccount -TenantId $tenantId | Out-Null 
        } else { 
            Connect-AzAccount | Out-Null 
        }
        $context = Get-AzContext
    }
    
    if ($context.Subscription.Id -ne $subscriptionId) {
        Set-AzContext -SubscriptionId $subscriptionId | Out-Null
    }
    
    return $context
}

# Export functions for use in other scripts
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
