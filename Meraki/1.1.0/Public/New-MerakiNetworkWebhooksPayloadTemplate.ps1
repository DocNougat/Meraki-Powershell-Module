function New-MerakiNetworkWebhooksPayloadTemplate {
    <#
    .SYNOPSIS
    Creates a new payload template for webhooks for a network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkWebhooksPayloadTemplate function allows you to create a new payload template for webhooks for a network by providing the authentication token, network ID, and a JSON configuration for the payload template.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new payload template for webhooks.

    .PARAMETER PayloadTemplateConfig
    The JSON configuration for the payload template to be created. Refer to the JSON schema for required parameters and their format.

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
    } | ConvertTo-Json -Compress

    New-MerakiNetworkWebhooksPayloadTemplate -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -PayloadTemplateConfig $PayloadTemplateConfig

    This example creates a new payload template for webhooks for the Meraki network with ID "L_123456789012345678" with the specified configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$PayloadTemplateConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $PayloadTemplateConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/payloadTemplates"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}