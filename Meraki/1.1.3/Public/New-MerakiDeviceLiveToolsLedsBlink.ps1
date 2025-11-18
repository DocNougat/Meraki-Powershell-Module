function New-MerakiDeviceLiveToolsLedsBlink {
<#
.SYNOPSIS
Sends a request to a Meraki device to blink its LEDs using Live Tools.

.DESCRIPTION
New-MerakiDeviceLiveToolsLedsBlink issues a POST to the Meraki Live Tools LEDs blink endpoint for the specified device serial.
Provide an API key, the device serial, and a BlinkParameters object (or JSON string) that follows the Blink Parameters schema described below.

.PARAMETER AuthToken
The Meraki API key used for authentication. Sent as the X-Cisco-Meraki-API-Key header.

.PARAMETER Serial
The Meraki device serial number for which the LEDs should blink.

.PARAMETER BlinkParameters
A JSON string that represents the Blink Parameters object.

.EXAMPLE
# Provide BlinkParameters as a PowerShell hashtable and convert to JSON before calling:
$blinkParams = @{
    duration = 10
} | ConvertTo-Json -Depth 10
New-MerakiDeviceLiveToolsLedsBlink -AuthToken $apiKey -Serial 'Q2XX-XXXX-XXXX' -BlinkParameters $blinkParams

.NOTES
- BlinkParameters must be valid JSON when passed as a string; when passing a PowerShell object, convert to JSON (ConvertTo-Json) if the function expects a JSON body.
- Ensure the API key has sufficient privileges to call device Live Tools endpoints.
#>    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$BlinkParameters
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/leds/blink"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $BlinkParameters
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}