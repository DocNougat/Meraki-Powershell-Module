function Get-MerakiNetworkNetflow {
    <#
    .SYNOPSIS
    Retrieves NetFlow traffic data for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkNetflow function retrieves NetFlow traffic data for a specified Meraki network using the Meraki API. You must provide an API authentication token and the network ID as parameters.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve NetFlow traffic data for.

    .EXAMPLE
    Get-MerakiNetworkNetflow -AuthToken '12345' -NetworkId 'L_123456789'

    This example retrieves NetFlow traffic data for the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/netflow" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}