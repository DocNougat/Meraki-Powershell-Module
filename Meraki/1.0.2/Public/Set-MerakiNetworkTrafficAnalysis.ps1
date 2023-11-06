function Set-MerakiNetworkTrafficAnalysis {
    <#
    .SYNOPSIS
    Updates the traffic analysis settings of an existing Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkTrafficAnalysis function allows you to update the traffic analysis settings of an existing Meraki network by providing the authentication token, network ID, and a JSON configuration for the traffic analysis settings.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the traffic analysis settings.

    .PARAMETER TrafficAnalysisConfig
    The JSON configuration for the traffic analysis settings to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $TrafficAnalysisConfig = '{
        "mode": "detailed",
        "customPieChartItems": [
            {
                "name": "Item from hostname",
                "type": "host",
                "value": "example.com"
            },
            {
                "name": "Item from port",
                "type": "port",
                "value": "440"
            },
            {
                "name": "Item from IP",
                "type": "ipRange",
                "value": "192.1.0.0"
            },
            {
                "name": "Item from IP range (CIDR)",
                "type": "ipRange",
                "value": "192.2.0.0/16"
            },
            {
                "name": "Item from IP range with port",
                "type": "ipRange",
                "value": "192.3.0.0/16:80"
            }
        ]
    }'
    $TrafficAnalysisConfig = $TrafficAnalysisConfig | ConvertTo-JSON -compress

    Set-MerakiNetworkTrafficAnalysis -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -TrafficAnalysisConfig $TrafficAnalysisConfig

    This example updates the traffic analysis settings of the Meraki network with ID "L_123456789012345678" to enable detailed traffic analysis and add custom pie chart items for traffic reporting.

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
        [string]$TrafficAnalysisConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $TrafficAnalysisConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/trafficAnalysis"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}