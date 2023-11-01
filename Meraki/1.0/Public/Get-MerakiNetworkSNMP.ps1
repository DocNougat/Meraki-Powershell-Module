function Get-MerakiNetworkSNMP {
    <#
    .SYNOPSIS
    Retrieves SNMP settings for a Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkSNMP function retrieves SNMP settings for a specified Meraki network using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The Meraki Dashboard API authentication token.

    .PARAMETER NetworkId
    The ID of the network for which to retrieve SNMP settings.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSNMP -AuthToken "1234" -NetworkId "N_1234567890"

    This example retrieves SNMP settings for the network with ID "N_1234567890" using the Meraki Dashboard API authentication token "1234".

    .NOTES
    For more information on SNMP settings and the Meraki Dashboard API, please refer to the Meraki API documentation: https://developer.cisco.com/meraki/api-v1/#!get-network-snmp
    #>
    [CmdletBinding()]
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

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/snmp" -Header $header

        return $response
    }
    catch {
        Write-Error $_
    }
}
