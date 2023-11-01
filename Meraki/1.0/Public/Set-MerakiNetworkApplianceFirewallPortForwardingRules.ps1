function Set-MerakiNetworkApplianceFirewallPortForwardingRules {
    <#
    .SYNOPSIS
    Updates the port forwarding rules for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceFirewallPortForwardingRules function allows you to update the port forwarding rules for a network's appliances by providing the authentication token, network ID, and a firewall configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the port forwarding rules.

    .PARAMETER FirewallConfig
    A string containing the firewall configuration. The string should be in JSON format and should include the "rules" array, which contains objects with the "lanIp", "allowedIps", "name", "protocol", "publicPort", "localPort", and "uplink" properties.

    .EXAMPLE
    $config = '{
        "rules": [
            {
                "lanIp": "192.168.128.1",
                "allowedIps": [ "any" ],
                "name": "Description of Port Forwarding Rule",
                "protocol": "tcp",
                "publicPort": "8100-8101",
                "localPort": "442-443",
                "uplink": "both"
            }
        ]
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceFirewallPortForwardingRules -AuthToken "your-api-token" -NetworkId "your-network-id" -FirewallConfig $config

    This example updates the port forwarding rules for the network with ID "your-network-id", using the specified firewall configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$FirewallConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FirewallConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/portForwardingRules"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}