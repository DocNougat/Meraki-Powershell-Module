function Get-MerakiNetworkWirelessSsidVPN {
    <#
    .SYNOPSIS
    Retrieves VPN settings for a wireless SSID in a Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkWirelessSsidVPN function retrieves the VPN settings for a wireless SSID in a Meraki network using the Meraki Dashboard API. You must provide an API key and the ID of the network and SSID.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER networkId
    The ID of the network that the SSID belongs to.

    .PARAMETER SSIDNumber
    The number of the SSID to retrieve the VPN settings for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessSsidVPN -AuthToken "your_api_key" -networkId "your_network_id" -number "1"

    Retrieves the VPN settings for the first wireless SSID in the specified network.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId,
        [Parameter(Mandatory=$true)]
        [string]$SSIDNumber
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/ssids/$SSIDNumber/vpn" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error $_
    }
}
