function Get-MerakiNetworkApplianceTrafficShapingUplinkBandwidth {
    <#
    .SYNOPSIS
    Retrieves the uplink bandwidth settings for a network's traffic shaping configuration.

    .DESCRIPTION
    The Get-MerakiNetworkApplianceTrafficShapingUplinkBandwidth function retrieves the uplink bandwidth settings for a network's traffic shaping configuration using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The API token generated in the Meraki Dashboard.

    .PARAMETER NetworkId
    The network ID of the Meraki network to query.

    .EXAMPLE
    Get-MerakiNetworkApplianceTrafficShapingUplinkBandwidth -AuthToken '1234' -NetworkId 'L_1234567890123456789'

    This example retrieves the uplink bandwidth settings for the specified Meraki network.

    .NOTES
    For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
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
        
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/uplinkBandwidth" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
