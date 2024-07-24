function Set-MerakiNetworkApplianceFirewallInboundFirewallRules {
    <#
    .SYNOPSIS
    Updates the inbound firewall rules for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceFirewallInboundFirewallRules function allows you to update the inbound firewall rules for a network's appliances by providing the authentication token, network ID, and a firewall configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the inbound firewall rules.

    .PARAMETER FirewallConfig
    A string containing the firewall configuration. The string should be in JSON format and should include the "rules" array, which contains objects with the "comment", "policy", "protocol", "destPort", "destCidr", "srcPort", "srcCidr", and "syslogEnabled" properties, as well as the "syslogDefaultRule" boolean property.

    .EXAMPLE
    $config = [PSCustomObject]@{
        rules = @(
            [PSCustomObject]@{
                comment = "Allow TCP traffic to subnet with HTTP servers."
                policy = "allow"
                protocol = "tcp"
                destPort = "443"
                destCidr = "192.168.1.0/24"
                srcPort = "Any"
                srcCidr = "Any"
                syslogEnabled = $false
            }
        )
        syslogDefaultRule = $true
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceFirewallInboundFirewallRules -AuthToken "your-api-token" -NetworkId "your-network-id" -FirewallConfig $config

    This example updates the inbound firewall rules for the network with ID "your-network-id", using the specified firewall configuration.

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

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/inboundFirewallRules"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}