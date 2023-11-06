function Set-MerakiNetworkApplianceConnectivityMonitoringDestinations {
    <#
    .SYNOPSIS
    Updates the connectivity monitoring destinations for a network's appliances using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceConnectivityMonitoringDestinations function allows you to update the connectivity monitoring destinations for a network's appliances by providing the authentication token, network ID, and a monitoring configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the connectivity monitoring destinations.

    .PARAMETER MonitoringConfig
    A string containing the monitoring configuration. The string should be in JSON format and should include the "destinations" array, which contains objects with the "ip", "description", and "default" properties.

    .EXAMPLE
    $config = '{
        "destinations": [
            {
                "ip": "8.8.8.8",
                "description": "Google",
                "default": false
            },
            {
                "ip": "1.23.45.67",
                "description": "test description",
                "default": true
            },
            { "ip": "9.8.7.6" }
        ]
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceConnectivityMonitoringDestinations -AuthToken "your-api-token" -NetworkId "your-network-id" -MonitoringConfig $config

    This example updates the connectivity monitoring destinations for the network with ID "your-network-id", using the specified monitoring configuration.

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
        [string]$MonitoringConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $MonitoringConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/connectivityMonitoringDestinations"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}