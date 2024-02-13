function Set-MerakiNetworkApplianceFirewallSettings {
    <#
    .SYNOPSIS
    Updates the firewall settings for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceFirewallSettings function allows you to update the firewall settings for a network's appliances by providing the authentication token, network ID, and a firewall configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the firewall settings.

    .PARAMETER FirewallConfig
    A string containing the firewall configuration. The string should be in JSON format and should include the "spoofingProtection" object, which contains the "ipSourceGuard" object with the "mode" property.

    .EXAMPLE
    $config = [PSCustomObject]@{
        spoofingProtection = @{
            ipSourceGuard = @{
                mode = "block"
            }
        }
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceFirewallSettings -AuthToken "your-api-token" -NetworkId "your-network-id" -FirewallConfig $config

    This example updates the firewall settings for the network with ID "your-network-id", using the specified firewall configuration.

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

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/settings"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}