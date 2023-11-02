function New-MerakiNetworkApplianceTrafficShapingCPC {
    <#
    .SYNOPSIS
    Creates a new custom performance class for traffic shaping in a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkApplianceTrafficShapingCPC function allows you to create a new custom performance class for traffic shaping in a specified Meraki network by providing the authentication token, network ID, and a custom performance class configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new custom performance class.

    .PARAMETER PerformanceClassConfig
    A string containing the custom performance class configuration. The string should be in JSON format and should include the "name", "maxLatency", "maxJitter", and "maxLossPercentage" properties.

    .EXAMPLE
    $config = '{
        "name": "myCustomPerformanceClass",
        "maxLatency": 100,
        "maxJitter": 100,
        "maxLossPercentage": 5
    }'
    $config = $config | ConvertTo-Json -Compress
    New-MerakiNetworkApplianceTrafficShapingCPC -AuthToken "your-api-token" -NetworkId "your-network-id" -PerformanceClassConfig $config

    This example creates a new custom performance class for traffic shaping in the Meraki network with ID "your-network-id" using the specified custom performance class configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the custom performance class creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$PerformanceClassConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $PerformanceClassConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/customPerformanceClasses"
        $response = Invoke-RestMethod -Method Post -Uri $uri -Header $header -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}