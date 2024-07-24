function Invoke-MerakiWipeNetworkSmDevices {
    <#
    .SYNOPSIS
    Wipes a device in a network.

    .DESCRIPTION
    This function allows you to wipe a device in a given network by providing the authentication token, network ID, and optional parameters for pin, device ID, serial, and wifi MAC address.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER Pin
    The pin number (a six digit value) for wiping a macOS device. Required only for macOS devices.

    .PARAMETER Id
    The ID of the device to be wiped.

    .PARAMETER Serial
    The serial of the device to be wiped.

    .PARAMETER WifiMac
    The wifi MAC address of the device to be wiped.

    .EXAMPLE
    Invoke-MerakiWipeNetworkSmDevices -AuthToken "your-api-token" -NetworkId "123456" -Id "deviceId1" -Pin 123456

    This example wipes the specified device in the network with ID "123456" with the given pin for a macOS device.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [int]$Pin,
        [parameter(Mandatory=$false)]
        [string]$Id,
        [parameter(Mandatory=$false)]
        [string]$Serial,
        [parameter(Mandatory=$false)]
        [string]$WifiMac
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{}

        if ($Pin) {
            $body.pin = $Pin
        }

        if ($Id) {
            $body.id = $Id
        }

        if ($Serial) {
            $body.serial = $Serial
        }

        if ($WifiMac) {
            $body.wifiMac = $WifiMac
        }

        $bodyJson = $body | ConvertTo-Json -Compress

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/wipe"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
