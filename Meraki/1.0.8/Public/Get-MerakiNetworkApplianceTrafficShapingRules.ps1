function Get-MerakiNetworkApplianceTrafficShapingRules {
    <#
    .SYNOPSIS
    Retrieves the traffic shaping rules for a given network's appliance.

    .DESCRIPTION
    This function retrieves the traffic shaping rules for a given network's appliance. The rules determine how network traffic is prioritized, limited, or blocked.

    .PARAMETER AuthToken
    The Meraki API token for the calling user.

    .PARAMETER NetworkId
    The ID of the network to retrieve traffic shaping rules for.

    .EXAMPLE
    Get-MerakiNetworkApplianceTrafficShapingRules -AuthToken '1234' -NetworkId 'N_12345'

    This example retrieves the traffic shaping rules for the network with ID 'N_12345'.

    .NOTES
    For more information on traffic shaping rules and the Meraki API, visit https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-traffic-shaping-rules
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/rules" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    } 
    catch {
        Write-Debug $_
        Throw $_
    }
}
