function Set-MerakiNetworkApplianceTrafficShapingUplinkBandwidth {
    <#
    .SYNOPSIS
    Updates the uplink bandwidth settings for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceTrafficShapingUplinkBandwidth function allows you to update the uplink bandwidth settings for a specified Meraki network by providing the authentication token, network ID, and an uplink bandwidth configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the uplink bandwidth settings.

    .PARAMETER UplinkBandwidthConfig
    A string containing the uplink bandwidth configuration. The string should be in JSON format and should include the "bandwidthLimits" property with "wan1", "wan2", and "cellular" sub-properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        bandwidthLimits = [PSCustomObject]@{
            wan1 = [PSCustomObject]@{
                limitUp = 1000
                limitDown = 1000
            }
            wan2 = [PSCustomObject]@{
                limitUp = 1000
                limitDown = 1000
            }
            cellular = [PSCustomObject]@{
                limitUp = 1000
                limitDown = 1000
            }
        }
    }
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceTrafficShapingUplinkBandwidth -AuthToken "your-api-token" -NetworkId "your-network-id" -UplinkBandwidthConfig $config

    This example updates the uplink bandwidth settings for the Meraki network with ID "your-network-id" using the specified uplink bandwidth configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the uplink bandwidth update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$UplinkBandwidthConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $UplinkBandwidthConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/uplinkBandwidth"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}