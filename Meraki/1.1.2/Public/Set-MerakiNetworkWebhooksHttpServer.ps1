function Set-MerakiNetworkWebhooksHttpServer {
    <#
    .SYNOPSIS
    Updates an existing HTTP server for webhooks for a network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkWebhooksHttpServer function allows you to update an existing HTTP server for webhooks for a network by providing the authentication token, network ID, HTTP server ID, and a JSON configuration for the HTTP server.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update an existing HTTP server for webhooks.

    .PARAMETER HttpServerId
    The ID of the HTTP server for which you want to update the configuration.

    .PARAMETER WebhookServerConfig
    The JSON configuration for the HTTP server to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $WebhookServerConfig = [PSCustomObject]@{
        name = "Example Webhook Server"
        sharedSecret = "shhh"
        payloadTemplate = @{
            payloadTemplateId = "wpt_00001"
        }
    }

    $WebhookServerConfig = $WebhookServerConfig | ConvertTo-Json -Compress

    Set-MerakiNetworkWebhooksHttpServer -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -HttpServerId "1234" -WebhookServerConfig $WebhookServerConfig

    This example updates the configuration of the HTTP server with ID "1234" for the Meraki network with ID "L_123456789012345678" with the specified configuration.

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
        [string]$HttpServerId,
        [parameter(Mandatory=$true)]
        [string]$WebhookServerConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $WebhookServerConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/httpServers/$HttpServerId"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}