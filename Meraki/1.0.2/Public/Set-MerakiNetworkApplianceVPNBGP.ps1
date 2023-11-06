function Set-MerakiNetworkApplianceVPNBGP {
    <#
    .SYNOPSIS
    Updates the VPN BGP settings for a Meraki network.
    
    .DESCRIPTION
    This function updates the VPN BGP settings for a Meraki network using the Meraki Dashboard API. The function takes a JSON configuration as input and sends it to the API endpoint to update the VPN BGP settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the VPN BGP settings.
    
    .PARAMETER BGPConfig
    The JSON configuration for the VPN BGP settings to be updated. Refer to the JSON schema for required parameters and their format.
    
    .EXAMPLE
    $BGPConfig = '{
        "enabled": true,
        "asNumber": 64515,
        "ibgpHoldTimer": 120,
        "neighbors": [
            {
                "ip": "10.10.10.22",
                "remoteAsNumber": 64343,
                "receiveLimit": 120,
                "allowTransit": true,
                "ebgpHoldTimer": 180,
                "ebgpMultihop": 2
            }
        ]
    }'
    $BGPConfig = $BGPConfig | ConvertTo-JSON -compress
    
    Set-MerakiNetworkApplianceVPNBGP -AuthToken "your-api-token" -NetworkId "L_9817349871234" -BGPConfig $BGPConfig
    
    This example updates the VPN BGP settings for the specified network.
    
    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [Parameter(Mandatory = $true)]
            [string]$BGPConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $BGPConfig
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vpn/bgp"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }