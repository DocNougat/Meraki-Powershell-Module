function Get-MerakiNetworkAuthUsers {
    <#
        .SYNOPSIS
        Retrieves a list of Meraki authentication users for a given network.

        .DESCRIPTION
        This function retrieves a list of Meraki authentication users for a given network.

        .PARAMETER AuthToken
        The Meraki API authentication token.

        .PARAMETER NetworkId
        The network ID of the network to retrieve Meraki authentication users from.

        .EXAMPLE
        PS C:\> Get-MerakiNetworkAuthUsers -AuthToken "1234" -NetworkId "L_123456789012345678"

        Retrieves a list of Meraki authentication users for the network with the ID "L_123456789012345678".

        .NOTES
        For more information on the Meraki Dashboard API and available parameters, see the official documentation:
        https://developer.cisco.com/meraki/api-v1/#!get-network-meraki-auth-users
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/merakiAuthUsers" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    } 
    catch {
        Write-Debug $_
        Throw $_
    }
}
