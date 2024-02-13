function Get-MerakiNetworkSecurityIntrusion {
    <#
    .SYNOPSIS
    Retrieves intrusion security settings for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkSecurityIntrusion function retrieves the intrusion security settings for a specified Meraki network using the Meraki API. You must provide an API authentication token and the network ID as parameters.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve intrusion security settings for.

    .EXAMPLE
    Get-MerakiNetworkSecurityIntrusion -AuthToken '12345' -NetworkId 'L_123456789'

    This example retrieves the intrusion security settings for the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/security/intrusion" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
