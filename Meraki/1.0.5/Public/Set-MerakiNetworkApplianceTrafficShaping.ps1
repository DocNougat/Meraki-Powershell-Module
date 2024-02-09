function Set-MerakiNetworkApplianceTrafficShaping {
    <#
    .SYNOPSIS
    Updates the traffic shaping configuration for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceTrafficShaping function allows you to update the traffic shaping configuration for a specified Meraki network by providing the authentication token, network ID, and a traffic shaping configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the traffic shaping configuration.

    .PARAMETER TrafficShapingConfig
    A string containing the traffic shaping configuration. The string should be in JSON format and should include the "globalBandwidthLimits" property, which should be an object containing the "limitUp" and "limitDown" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        globalBandwidthLimits = @{
            limitUp = 2048
            limitDown = 5120
        }
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceTrafficShaping -AuthToken "your-api-token" -NetworkId "your-network-id" -TrafficShapingConfig $config

    This example updates the traffic shaping configuration for the Meraki network with ID "your-network-id" using the specified traffic shaping configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the traffic shaping configuration update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$TrafficShapingConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $TrafficShapingConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}