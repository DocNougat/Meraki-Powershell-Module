function Set-MerakiNetworkApplianceFirewallFirewalledService {
    <#
    .SYNOPSIS
    Updates the firewalled service settings for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceFirewallFirewalledService function allows you to update the firewalled service settings for a network's appliances by providing the authentication token, network ID, service name, and a firewall configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the firewalled service settings.

    .PARAMETER ServiceName
    The name of the firewalled service for which you want to update the settings.

    .PARAMETER FirewallConfig
    A string containing the firewall configuration. The string should be in JSON format and should include the "access" and "allowedIps" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        access = "restricted"
        allowedIps = @("123.123.123.1","123.123.123.2")
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceFirewallFirewalledService -AuthToken "your-api-token" -NetworkId "your-network-id" -ServiceName "your-service-name" -FirewallConfig $config

    This example updates the firewalled service settings for the network with ID "your-network-id" and service name "your-service-name", using the specified firewall configuration.

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
        [string]$ServiceName,
        [parameter(Mandatory=$true)]
        [string]$FirewallConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FirewallConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/firewalledServices/$ServiceName"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}