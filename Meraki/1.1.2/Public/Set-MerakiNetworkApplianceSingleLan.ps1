function Set-MerakiNetworkApplianceSingleLan {
    <#
    .SYNOPSIS
    Updates the single LAN configuration for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceSingleLan function allows you to update the single LAN configuration for a specified Meraki network by providing the authentication token, network ID, and a single LAN configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the single LAN configuration.

    .PARAMETER SingleLanConfig
    A string containing the single LAN configuration. The string should be in JSON format and should include the "applianceIp", "subnet", "ipv6", and "mandatoryDHCP" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        applianceIp = "192.168.1.1"
        subnet = "192.168.1.0/24"
        ipv6 = @{
            enabled = $true
            prefixAssignments = @(
                @{
                    staticPrefix = "2001:db8:abcd:0012::/64"
                    autonomous = $true
                    origin = @{
                        type = "internet"
                    }
                    interfaces = @("lan")
                }
            )
            staticApplianceIp6 = "2001:db8:abcd:0012::1"
        }
        mandatoryDHCP = @{
            enabled = $true
        }
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceSingleLan -AuthToken "your-api-token" -NetworkId "your-network-id" -SingleLanConfig $config

    This example updates the single LAN configuration for the Meraki network with ID "your-network-id", using the specified single LAN configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the single LAN configuration update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SingleLanConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $SingleLanConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/singleLan"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}