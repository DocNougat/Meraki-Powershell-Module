function Set-MerakiNetworkWirelessSSIDTrafficShapingRules {
    <#
    .SYNOPSIS
    Updates the traffic shaping rules for a network's wireless SSID using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkWirelessSSIDTrafficShapingRules function allows you to update the traffic shaping rules for a network's wireless SSID by providing the authentication token, network ID, SSID number, and a traffic shaping rules configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the SSID traffic shaping rules.

    .PARAMETER SSIDNumber
    The number of the SSID to update the traffic shaping rules for.

    .PARAMETER TrafficShapingRules
    A string containing the SSID traffic shaping rules configuration. The string should be in JSON format and should include the properties as defined in the schema.

    .EXAMPLE
    $trafficShapingRules = [PSCustomObject]@{
        trafficShapingEnabled = $true
        defaultRulesEnabled = $true
        rules = @(
            [PSCustomObject]@{
                definitions = @(
                    [PSCustomObject]@{
                        type = "host"
                        value = "google.com"
                    }
                )
                perClientBandwidthLimits = [PSCustomObject]@{
                    settings = "custom"
                    bandwidthLimits = [PSCustomObject]@{
                        limitUp = 1000
                        limitDown = 1000
                    }
                }
                dscpTagValue = 0
                pcpTagValue = 0
            }
        )
    }

    $trafficShapingRules = $trafficShapingRules | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSSIDTrafficShapingRules -AuthToken "your-api-token" -NetworkId "your-network-id" -SSIDNumber "1" -TrafficShapingRules $trafficShapingRules

    This example updates the traffic shaping rules for the SSID with number 1 in the network with ID "your-network-id", using the specified traffic shaping rules configuration.

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
        [string]$TrafficShapingRules
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $TrafficShapingRules

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/trafficShaping/rules"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}