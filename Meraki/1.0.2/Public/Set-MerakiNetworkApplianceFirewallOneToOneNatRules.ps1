function Set-MerakiNetworkApplianceFirewallOneToOneNatRules {
    <#
    .SYNOPSIS
    Updates the One-to-One NAT rules for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceFirewallOneToOneNatRules function allows you to update the One-to-One NAT rules for a network's appliances by providing the authentication token, network ID, and a firewall configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the One-to-One NAT rules.

    .PARAMETER FirewallConfig
    A string containing the firewall configuration. The string should be in JSON format and should include the "rules" array, which contains objects with the "name", "lanIp", "publicIp", "uplink", "allowedInbound", "protocol", "allowedIps", and "destinationPorts" properties.

    .EXAMPLE
    $config = '{
        "rules": [
            {
                "name": "Service behind NAT",
                "lanIp": "192.168.128.22",
                "publicIp": "146.12.3.33",
                "uplink": "internet1",
                "allowedInbound": [
                    {
                        "protocol": "tcp",
                        "destinationPorts": [ "80" ],
                        "allowedIps": [
                            "10.82.112.0/24",
                            "10.82.0.0/16"
                        ]
                    },
                    {
                        "protocol": "udp",
                        "destinationPorts": [ "8080" ],
                        "allowedIps": [
                            "10.81.110.5",
                            "10.81.0.0/16"
                        ]
                    }
                ]
            }
        ]
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceFirewallOneToOneNatRules -AuthToken "your-api-token" -NetworkId "your-network-id" -FirewallConfig $config

    This example updates the One-to-One NAT rules for the network with ID "your-network-id", using the specified firewall configuration.

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

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/oneToOneNatRules"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}