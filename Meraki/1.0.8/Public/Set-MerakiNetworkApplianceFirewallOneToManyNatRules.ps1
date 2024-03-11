function Set-MerakiNetworkApplianceFirewallOneToManyNatRules {
    <#
    .SYNOPSIS
    Updates the One-to-Many NAT rules for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceFirewallOneToManyNatRules function allows you to update the One-to-Many NAT rules for a network's appliances by providing the authentication token, network ID, and a firewall configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the One-to-Many NAT rules.

    .PARAMETER FirewallConfig
    A string containing the firewall configuration. The string should be in JSON format and should include the "rules" array, which contains objects with the "publicIp", "uplink", "portRules", "localIp", "localPort", "name", "protocol", "publicPort", and "allowedIps" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        rules = @(
            [PSCustomObject]@{
                publicIp = "146.11.11.13"
                uplink = "internet1"
                portRules = @(
                    [PSCustomObject]@{
                        name = "Rule 1"
                        protocol = "tcp"
                        publicPort = "9443"
                        localIp = "192.168.128.1"
                        localPort = "443"
                        allowedIps = @("any")
                    },
                    [PSCustomObject]@{
                        name = "Rule 2"
                        protocol = "tcp"
                        publicPort = "8080"
                        localIp = "192.168.128.1"
                        localPort = "80"
                        allowedIps = @(
                            "10.82.110.0/24",
                            "10.82.111.0/24"
                        )
                    }
                )
            }
        )
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceFirewallOneToManyNatRules -AuthToken "your-api-token" -NetworkId "your-network-id" -FirewallConfig $config

    This example updates the One-to-Many NAT rules for the network with ID "your-network-id", using the specified firewall configuration.

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

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/oneToManyNatRules"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}