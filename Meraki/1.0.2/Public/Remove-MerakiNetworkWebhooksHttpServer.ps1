function Remove-MerakiNetworkWebhooksHttpServer {
    <#
    .SYNOPSIS
    Deletes an existing HTTP server for webhooks for a network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkWebhooksHttpServer function allows you to delete an existing HTTP server for webhooks for a network by providing the authentication token, network ID, and HTTP server ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete an existing HTTP server for webhooks.

    .PARAMETER HttpServerId
    The ID of the HTTP server you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkWebhooksHttpServer -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -HttpServerId "1234"

    This example deletes the HTTP server with ID "1234" for the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$HttpServerId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/httpServers/$HttpServerId"
        
        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
    }
}