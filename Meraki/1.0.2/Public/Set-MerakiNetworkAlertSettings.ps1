function Set-MerakiNetworkAlertSettings {
    <#
    .SYNOPSIS
    Updates the alert configuration for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkAlertSettings function allows you to update the alert configuration for a specified Meraki network by providing the authentication token, network ID, and alert configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network to be updated.

    .PARAMETER AlertSettingsConfig
    The JSON configuration for the alert settings to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $AlertSettingsConfig = '{
        "defaultDestinations": {
            "allAdmins": true,
            "snmp": true,
            "emails": ["alerts@example.com", "alerts2@example.com"],
            "httpServerIds": []
        },
        "muting": {
            "byPortSchedules": {
                "enabled": true
            }
        },
        "alerts": [
            {
                "type": "gatewayDown",
                "enabled": true,
                "alertDestinations": {
                    "allAdmins": true,
                    "snmp": true,
                    "emails": ["alerts@example.com", "alerts2@example.com"],
                    "httpServerIds": []
                },
                "filters": {}
            }
        ]
    }'
    $AlertSettingsConfig = $AlertSettingsConfig | ConvertTo-JSON -compress

    Set-MerakiNetworkAlertSettings -AuthToken "your-api-token" -NetworkId "L_1234567890" -AlertSettingsConfig $AlertSettingsConfig

    This example updates the alert configuration for the network with ID "L_1234567890" to have the default destinations for all alerts set to send to "alerts@example.com" and "alerts2@example.com", mute wireless unreachable alerts based on switch port schedules, and enable gateway down alerts to send to "alerts@example.com" and "alerts2@example.com".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$AlertSettingsConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $AlertSettingsConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/alerts/settings"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}