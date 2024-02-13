function Get-MerakiNetworkApplianceTrafficShapingUplinkSelection {
    <#
    .SYNOPSIS
    Retrieves the uplink selection settings for an MX network.

    .DESCRIPTION
    This function retrieves the uplink selection settings for an MX network.

    .PARAMETER AuthToken
    The Meraki Dashboard API key to use for the request.

    .PARAMETER NetworkId
    The ID of the network to retrieve the uplink selection settings for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceTrafficShapingUplinkSelection -AuthToken "1234" -NetworkId "N_123456"

    This example retrieves the uplink selection settings for the network with ID "N_123456" using the Meraki Dashboard API key "1234".

    .NOTES
    For more information on the API endpoint, see: https://developer.cisco.com/meraki/api/#!get-network-appliance-traffic-shaping-uplink-selection
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/uplinkSelection" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}