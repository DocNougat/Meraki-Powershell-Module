function New-MerakiNetworkWebhooksHttpServer {
    <#
    .SYNOPSIS
    Creates a new HTTP server for webhooks for a network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkWebhooksHttpServer function allows you to create a new HTTP server for webhooks for a network by providing the authentication token, network ID, and a JSON configuration for the HTTP server.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new HTTP server for webhooks.

    .PARAMETER WebhookServerConfig
    The JSON configuration for the HTTP server to be created. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $WebhookServerConfig = [PSCustomObject]@{
        name = "Example Webhook Server"
        url = "https://example.com"
        sharedSecret = "shhh"
        payloadTemplate = [PSCustomObject]@{
            payloadTemplateId = "wpt_00001"
            name = "Meraki (included)"
        }
    }

    $WebhookServerConfig = $WebhookServerConfig | ConvertTo-JSON -Compress

    New-MerakiNetworkWebhooksHttpServer -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -WebhookServerConfig $WebhookServerConfig

    This example creates a new HTTP server for webhooks for the Meraki network with ID "L_123456789012345678" with the specified configuration.

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
        [string]$WebhookServerConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $WebhookServerConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/httpServers"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}