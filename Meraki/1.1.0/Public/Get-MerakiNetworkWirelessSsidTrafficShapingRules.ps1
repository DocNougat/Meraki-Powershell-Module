function Get-MerakiNetworkWirelessSsidTrafficShapingRules {
    <#
    .SYNOPSIS
    Retrieves traffic shaping rules for a wireless SSID in a Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkWirelessSsidTrafficShapingRules function retrieves the traffic shaping rules for a wireless SSID in a Meraki network using the Meraki Dashboard API. You must provide an API key and the ID of the network and SSID.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER networkId
    The ID of the network that the SSID belongs to.

    .PARAMETER SSIDNumber
    The number of the SSID to retrieve the traffic shaping rules for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessSsidTrafficShapingRules -AuthToken "your_api_key" -networkId "your_network_id" -SSIDNumber "1"

    Retrieves the traffic shaping rules for the first wireless SSID in the specified network.

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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/ssids/$SSIDNumber/trafficShaping/rules" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
