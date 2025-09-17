@description('The location of the resources')
param location string = 'Australia East'
@description('The name of the Data Collection Endpoint Id')
param dataCollectionEndpointId string
@description('The Log Analytics Workspace Id used for Sentinel')
param workspaceResourceId string
@description('The Target Sentinel workspace name')
param workspaceName string = 'sentinel-workspace'
@description('The Service Principal Object ID of the Entra App')
param servicePrincipalObjectId string

// ============================================================================
// Data Collection Rule for ApigeeX_CL
// ============================================================================
// Generated: 2025-09-18 08:37:13
// Table type: Custom (presumed custom for JSON exports)
// Schema imported from JSON export file
// Underscore columns filtered out
// Original columns: 84, DCR columns: 82 (Type column always filtered)
// Output stream: Custom-ApigeeX_CL
// Note: Input stream uses string/dynamic only. Type conversions in transform.
// ============================================================================

var roleDefinitionResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'dcr-${workspaceName}-ApigeeX_CL'
  location: location
  properties: {
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: {
      'Custom-ApigeeX_CL': {
        columns: [
          {
            name: 'TimeGenerated'
            type: 'string'
          }
          {
            name: 'TenantId'
            type: 'string'
          }
          {
            name: 'payload_request_reportTime'
            type: 'string'
          }
          {
            name: 'payloadtatus_message'
            type: 'string'
          }
          {
            name: 'payloadtatus_code'
            type: 'string'
          }
          {
            name: 'payload_response_apiProxyType'
            type: 'string'
          }
          {
            name: 'payload_responseeploymentType'
            type: 'string'
          }
          {
            name: 'payload_responseisplayName'
            type: 'string'
          }
          {
            name: 'payload_response_name'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_requestAttributesime'
            type: 'string'
          }
          {
            name: 'payload_response_type'
            type: 'string'
          }
          {
            name: 'payload_request_environmentisplayName'
            type: 'string'
          }
          {
            name: 'payload_request_environmentescription'
            type: 'string'
          }
          {
            name: 'payload_request_environmenteploymentType'
            type: 'string'
          }
          {
            name: 'payload_request_environment_apiProxyType'
            type: 'string'
          }
          {
            name: 'payload_request_name'
            type: 'string'
          }
          {
            name: 'payload_request_reportTime'
            type: 'string'
          }
          {
            name: 'payload_request_resources'
            type: 'string'
          }
          {
            name: 'payload_request_environment_name'
            type: 'string'
          }
          {
            name: 'log_name'
            type: 'string'
          }
          {
            name: 'insert_id'
            type: 'string'
          }
          {
            name: 'severity'
            type: 'string'
          }
          {
            name: 'payload_request_type'
            type: 'string'
          }
          {
            name: 'payload_request_instance'
            type: 'string'
          }
          {
            name: 'payload_request_instanceUid'
            type: 'string'
          }
          {
            name: 'payload_resourceName'
            type: 'string'
          }
          {
            name: 'payload_authorizationInfo'
            type: 'string'
          }
          {
            name: 'payload_methodName'
            type: 'string'
          }
          {
            name: 'payloaderviceName'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_requestAttributesime'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_callerSuppliedUserAgent'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_callerIp'
            type: 'string'
          }
          {
            name: 'payload_authenticationInfo_principalEmail'
            type: 'string'
          }
          {
            name: 'payload_type'
            type: 'string'
          }
          {
            name: 'resource_labels_project_id'
            type: 'string'
          }
          {
            name: 'resource_labelservice'
            type: 'string'
          }
          {
            name: 'resource_labels_method'
            type: 'string'
          }
          {
            name: 'resourceype'
            type: 'string'
          }
          {
            name: 'timestamp'
            type: 'string'
          }
          {
            name: 'payload_request__type'
            type: 'string'
          }
          {
            name: 'payload_request_resources'
            type: 'string'
          }
          {
            name: 'payload_request_instance'
            type: 'string'
          }
          {
            name: 'payload_request_instanceUid'
            type: 'string'
          }
          {
            name: 'payload_response_apiProxyType'
            type: 'string'
          }
          {
            name: 'payload_response_deploymentType'
            type: 'string'
          }
          {
            name: 'payload_response_displayName'
            type: 'string'
          }
          {
            name: 'payload_response_name'
            type: 'string'
          }
          {
            name: 'payload_response__type'
            type: 'string'
          }
          {
            name: 'payload_request_environment_name'
            type: 'string'
          }
          {
            name: 'payload_request_environment_displayName'
            type: 'string'
          }
          {
            name: 'payload_status_code'
            type: 'string'
          }
          {
            name: 'payload_request_environment_description'
            type: 'string'
          }
          {
            name: 'payload_request_environment_apiProxyType'
            type: 'string'
          }
          {
            name: 'payload_request_name'
            type: 'string'
          }
          {
            name: 'RawData'
            type: 'string'
          }
          {
            name: 'Computer'
            type: 'string'
          }
          {
            name: 'ManagementGroupName'
            type: 'string'
          }
          {
            name: 'MG'
            type: 'string'
          }
          {
            name: 'SourceSystem'
            type: 'string'
          }
          {
            name: 'payload_request_environment_deploymentType'
            type: 'string'
          }
          {
            name: 'payload_status_message'
            type: 'string'
          }
          {
            name: 'payload_request_reportTime'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_requestAttributes_time'
            type: 'string'
          }
          {
            name: 'payload_resourceName'
            type: 'string'
          }
          {
            name: 'payload_authorizationInfo'
            type: 'string'
          }
          {
            name: 'payload_methodName'
            type: 'string'
          }
          {
            name: 'payload_serviceName'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_requestAttributes_time'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_callerSuppliedUserAgent'
            type: 'string'
          }
          {
            name: 'payload_requestMetadata_callerIp'
            type: 'string'
          }
          {
            name: 'payload_authenticationInfo_principalEmail'
            type: 'string'
          }
          {
            name: 'payload__type'
            type: 'string'
          }
          {
            name: 'resource_labels_project_id'
            type: 'string'
          }
          {
            name: 'resource_labels_service'
            type: 'string'
          }
          {
            name: 'resource_labels_method'
            type: 'string'
          }
          {
            name: 'resource_type'
            type: 'string'
          }
          {
            name: 'timestamp'
            type: 'string'
          }
          {
            name: 'severity'
            type: 'string'
          }
          {
            name: 'insert_id_'
            type: 'string'
          }
          {
            name: 'log_name'
            type: 'string'
          }
          {
            name: 'payload_request_reportTime'
            type: 'string'
          }
          {
            name: 'payload_request_reportTime'
            type: 'string'
          }
        ]
      }
    }
    dataSources: {}
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'Sentinel-ApigeeX_CL'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Custom-ApigeeX_CL']
        destinations: ['Sentinel-ApigeeX_CL']
        transformKql: 'source | project TimeGenerated = todatetime(TimeGenerated), TenantId = toguid(TenantId), payload_request_reportTime = tostring(payload_request_reportTime), payloadtatus_message = tostring(payloadtatus_message), payloadtatus_code = tostring(payloadtatus_code), payload_response_apiProxyType = tostring(payload_response_apiProxyType), payload_responseeploymentType = tostring(payload_responseeploymentType), payload_responseisplayName = tostring(payload_responseisplayName), payload_response_name = tostring(payload_response_name), payload_requestMetadata_requestAttributesime = todatetime(payload_requestMetadata_requestAttributesime), payload_response_type = tostring(payload_response_type), payload_request_environmentisplayName = tostring(payload_request_environmentisplayName), payload_request_environmentescription = tostring(payload_request_environmentescription), payload_request_environmenteploymentType = tostring(payload_request_environmenteploymentType), payload_request_environment_apiProxyType = tostring(payload_request_environment_apiProxyType), payload_request_name = tostring(payload_request_name), payload_request_reportTime = todatetime(payload_request_reportTime), payload_request_resources = tostring(payload_request_resources), payload_request_environment_name = tostring(payload_request_environment_name), log_name = tostring(log_name), insert_id = tostring(insert_id), severity = tostring(severity), payload_request_type = tostring(payload_request_type), payload_request_instance = tostring(payload_request_instance), payload_request_instanceUid = tostring(payload_request_instanceUid), payload_resourceName = tostring(payload_resourceName), payload_authorizationInfo = tostring(payload_authorizationInfo), payload_methodName = tostring(payload_methodName), payloaderviceName = tostring(payloaderviceName), payload_requestMetadata_requestAttributesime = tostring(payload_requestMetadata_requestAttributesime), payload_requestMetadata_callerSuppliedUserAgent = tostring(payload_requestMetadata_callerSuppliedUserAgent), payload_requestMetadata_callerIp = tostring(payload_requestMetadata_callerIp), payload_authenticationInfo_principalEmail = tostring(payload_authenticationInfo_principalEmail), payload_type = tostring(payload_type), resource_labels_project_id = tostring(resource_labels_project_id), resource_labelservice = tostring(resource_labelservice), resource_labels_method = tostring(resource_labels_method), resourceype = tostring(resourceype), timestamp = todatetime(timestamp), payload_request__type = tostring(payload_request__type), payload_request_resources = tostring(payload_request_resources), payload_request_instance = tostring(payload_request_instance), payload_request_instanceUid = tostring(payload_request_instanceUid), payload_response_apiProxyType = tostring(payload_response_apiProxyType), payload_response_deploymentType = tostring(payload_response_deploymentType), payload_response_displayName = tostring(payload_response_displayName), payload_response_name = tostring(payload_response_name), payload_response__type = tostring(payload_response__type), payload_request_environment_name = tostring(payload_request_environment_name), payload_request_environment_displayName = tostring(payload_request_environment_displayName), payload_status_code = tostring(payload_status_code), payload_request_environment_description = tostring(payload_request_environment_description), payload_request_environment_apiProxyType = tostring(payload_request_environment_apiProxyType), payload_request_name = tostring(payload_request_name), RawData = tostring(RawData), Computer = tostring(Computer), ManagementGroupName = tostring(ManagementGroupName), MG = tostring(MG), SourceSystem = tostring(SourceSystem), payload_request_environment_deploymentType = tostring(payload_request_environment_deploymentType), payload_status_message = tostring(payload_status_message), payload_request_reportTime = tostring(payload_request_reportTime), payload_requestMetadata_requestAttributes_time = todatetime(payload_requestMetadata_requestAttributes_time), payload_resourceName = tostring(payload_resourceName), payload_authorizationInfo = tostring(payload_authorizationInfo), payload_methodName = tostring(payload_methodName), payload_serviceName = tostring(payload_serviceName), payload_requestMetadata_requestAttributes_time = tostring(payload_requestMetadata_requestAttributes_time), payload_requestMetadata_callerSuppliedUserAgent = tostring(payload_requestMetadata_callerSuppliedUserAgent), payload_requestMetadata_callerIp = tostring(payload_requestMetadata_callerIp), payload_authenticationInfo_principalEmail = tostring(payload_authenticationInfo_principalEmail), payload__type = tostring(payload__type), resource_labels_project_id = tostring(resource_labels_project_id), resource_labels_service = tostring(resource_labels_service), resource_labels_method = tostring(resource_labels_method), resource_type = tostring(resource_type), timestamp = todatetime(timestamp), severity = tostring(severity), insert_id_ = tostring(insert_id_), log_name = tostring(log_name), payload_request_reportTime = tostring(payload_request_reportTime), payload_request_reportTime = todatetime(payload_request_reportTime)'
        outputStream: 'Custom-ApigeeX_CL'
      }
    ]
  }
}

// Role Assignment to the DCR
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: dataCollectionRule
  name: guid(resourceGroup().id, roleDefinitionResourceId, dataCollectionRule.name)
  properties: {
    roleDefinitionId: roleDefinitionResourceId
    principalId: servicePrincipalObjectId
    principalType: 'ServicePrincipal'
  }
}

output immutableId string = dataCollectionRule.properties.immutableId
output dataCollectionRuleId string = dataCollectionRule.id
output dataCollectionRuleName string = dataCollectionRule.name
