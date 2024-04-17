Function Get-MerakiNetworkWebhooksHttpServer {
    <#
    .SYNOPSIS
    Retrieves a Meraki network webhook HTTP server.

    .DESCRIPTION
    This function retrieves a Meraki network webhook HTTP server using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The API token generated in the Meraki Dashboard.

    .PARAMETER httpServerId
    The ID of the HTTP server.

    .PARAMETER NetworkId
    The ID of the Meraki network.

    .EXAMPLE
    PS C:> Get-MerakiNetworkWebhooksHttpServer -AuthToken '12345' -httpServerId '123' -NetworkId 'N_1234567890'

    This command retrieves the HTTP server with the ID '123' for the Meraki network with the ID 'N_1234567890' using the API token '12345'.

    .INPUTS
    None.

    .OUTPUTS
    The function returns a Meraki network webhook HTTP server object.

    .NOTES
    For more information on the Meraki Dashboard API, please visit https://developer.cisco.com/meraki/api/.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$httpServerId,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/webhooks/httpServers/$httpServerId" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}