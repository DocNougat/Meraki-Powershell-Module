function Set-MerakiNetworkWirelessSSIDVPN {
    <#
    .SYNOPSIS
    Updates the VPN settings for a network's wireless SSID using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSIDVPN function allows you to update the VPN settings for a network's wireless SSID by providing the authentication token, network ID, SSID number, and a VPN configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the SSID VPN settings.

    .PARAMETER SSIDNumber
    The number of the SSID to update the VPN settings for.

    .PARAMETER VPNConfig
    A string containing the SSID VPN configuration. The string should be in JSON format and should include the properties as defined in the schema.

    .EXAMPLE
    $vpnConfig = [PSCustomObject]@{
        concentrator = @{
            networkId = "N_123"
            vlanId = 44
            name = "some concentrator name"
        }
        failover = @{
            requestIp = "1.1.1.1"
            heartbeatInterval = 10
            idleTimeout = 30
        }
        splitTunnel = @{
            enabled = $true
            rules = @(
                @{
                    protocol = "Any"
                    destCidr = "1.1.1.1/32"
                    destPort = "any"
                    policy = "allow"
                    comment = "split tunnel rule 1"
                },
                @{
                    destCidr = "foo.com"
                    destPort = "any"
                    policy = "deny"
                    comment = "split tunnel rule 2"
                }
            )
        }
    }

    $vpnConfig = $vpnConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSIDVPN -AuthToken "your-api-token" -NetworkId "your-network-id" -SSIDNumber "1" -VPNConfig $vpnConfig

    This example updates the VPN settings for the SSID with number 1 in the network with ID "your-network-id", using the specified VPN configuration.

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
        [string]$SSIDNumber,
        [parameter(Mandatory=$true)]
        [string]$VPNConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $VPNConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/vpn"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}