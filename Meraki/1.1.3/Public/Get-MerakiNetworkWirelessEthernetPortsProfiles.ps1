function Get-MerakiNetworkWirelessEthernetPortsProfiles {
    <#
.SYNOPSIS
Retrieves Ethernet port profiles for wireless devices in a Meraki network.

.DESCRIPTION
Calls the Meraki Dashboard API to fetch the list of Ethernet port profiles configured for wireless devices within the specified network.
The function issues a GET request to the endpoint:
    /networks/{networkId}/wireless/ethernet/ports/profiles
and returns the deserialized JSON response as PowerShell objects.

.PARAMETER AuthToken
The Meraki API key used for authentication. This value is sent in the "X-Cisco-Meraki-API-Key" request header.
Provide a valid API key with permissions to read network configuration.

.PARAMETER NetworkId
The identifier of the Meraki network to query (for example: L_1234567890123456). This value is used in the request path.

.EXAMPLE
# Use an environment variable to store the API key and retrieve profiles for the specified network
PS> $token = $env:MERAKI_API_KEY
PS> Get-MerakiNetworkWirelessEthernetPortsProfiles -AuthToken $token -NetworkId "L_1234567890123456"

This returns the list of ethernet port profile objects for wireless devices in the specified network.

.LINK
https://developer.cisco.com/meraki/api-v1/#!get-network-wireless-ethernet-ports-profiles
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
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ethernet/ports/profiles"

        $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
