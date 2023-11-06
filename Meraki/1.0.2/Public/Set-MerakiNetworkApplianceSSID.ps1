function Set-MerakiNetworkApplianceSSID {
    <#
    .SYNOPSIS
    Updates the SSID configuration for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceSSID function allows you to update the SSID configuration for a specified Meraki network by providing the authentication token, network ID, SSID number, and an SSID configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the SSID configuration.

    .PARAMETER SSIDNumber
    The number of the SSID you want to update.

    .PARAMETER SSIDConfig
    A string containing the SSID configuration. The string should be in JSON format and should include the "defaultVlanId", "authMode", "encryptionMode", "name", "psk", "wpaEncryptionMode", "enabled", "visible", "dhcpEnforcedDeauthentication", "dot11w", and "radiusServers" properties.

    .EXAMPLE
    $config = '{
        "name": "My SSID",
        "enabled": true,
        "defaultVlanId": 1,
        "authMode": "8021x-radius",
        "psk": "psk",
        "radiusServers": [
            {
                "host": "0.0.0.0",
                "port": 1000,
                "secret": "secret"
            }
        ],
        "encryptionMode": "wpa",
        "wpaEncryptionMode": "WPA2 only",
        "visible": true,
        "dhcpEnforcedDeauthentication": { "enabled": true },
        "dot11w": {
            "enabled": true,
            "required": true
        }
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceSSID -AuthToken "your-api-token" -NetworkId "your-network-id" -SSIDNumber 1 -SSIDConfig $config

    This example updates the SSID configuration for the Meraki network with ID "your-network-id" and SSID number 1, using the specified SSID configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the SSID configuration update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [int]$SSIDNumber,
        [parameter(Mandatory=$true)]
        [string]$SSIDConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $SSIDConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/ssids/$SSIDNumber"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}