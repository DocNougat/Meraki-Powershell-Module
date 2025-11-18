function Set-MerakiNetworkWebhooksPayloadTemplate {
    <#
    .SYNOPSIS
    Updates an existing payload template for webhooks for a network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkWebhooksPayloadTemplate function allows you to update an existing payload template for webhooks for a network by providing the authentication token, network ID, payload template ID, and a JSON configuration for the payload template.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update an existing payload template for webhooks.

    .PARAMETER PayloadTemplateId
    The ID of the payload template for which you want to update the configuration.

    .PARAMETER PayloadTemplateConfig
    The JSON configuration for the payload template to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $PayloadTemplateConfig = [PSCustomObject]@{
        name = "Custom Template"
        body = "{\"event_type\":\"{{alertTypeId}}\",\"client_payload\":{\"text\":\"{{alertData}}\"}}"
        headers = @(
            @{
                name = "Authorization"
                template = "Bearer {{sharedSecret}}"
            }
        )
        bodyFile = "Qm9keSBGaWxl"
        headersFile = "SGVhZGVycyBGaWxl"
    }

    $PayloadTemplateConfig = $PayloadTemplateConfig | ConvertTo-Json -Compress -Depth 4

    Set-MerakiNetworkWebhooksPayloadTemplate -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -PayloadTemplateId "wpt_00001" -PayloadTemplateConfig $PayloadTemplateConfig

    This example updates the configuration of the payload template with ID "wpt_00001" for the Meraki network with ID "L_123456789012345678" with the specified configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$PayloadTemplateId,
        [parameter(Mandatory=$true)]
        [string]$PayloadTemplateConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $PayloadTemplateConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/payloadTemplates/$PayloadTemplateId"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}