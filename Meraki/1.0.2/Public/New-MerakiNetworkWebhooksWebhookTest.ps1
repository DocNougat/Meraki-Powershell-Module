function New-MerakiNetworkWebhooksWebhookTest {
    <#
    .SYNOPSIS
    Creates a new webhook test for a network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkWebhooksWebhookTest function allows you to create a new webhook test for a network by providing the authentication token, network ID, and a JSON configuration for the webhook test.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new webhook test.

    .PARAMETER WebhookTestConfig
    The JSON configuration for the webhook test to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $WebhookTestConfig = '{
        "url": "https://www.example.com/path",
        "sharedSecret": "shhh",
        "payloadTemplateId": "wpt_00001",
        "payloadTemplateName": "Payload Template",
        "alertTypeId": "power_supply_down"
    }'
    $WebhookTestConfig = $WebhookTestConfig | ConvertTo-JSON -compress

    New-MerakiNetworkWebhooksWebhookTest -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -WebhookTestConfig $WebhookTestConfig

    This example creates a new webhook test for the Meraki network with ID "L_123456789012345678" with the specified configuration.

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
        [string]$WebhookTestConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $WebhookTestConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/webhookTests"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}