function Get-MerakiDeviceLiveToolsLedsBlink {
<#
.SYNOPSIS
Retrieves the current "leds blink" liveTools configuration for a specified Meraki device.

.DESCRIPTION
Get-MerakiDeviceLiveToolsLedsBlink queries the Cisco Meraki Dashboard API to obtain the liveTools "leds blink" resource for a device identified by its serial number. This returns the deserialized JSON response produced by the API, typically representing the LED blink configuration or status for the specified blink action ID.

.PARAMETER AuthToken
The Cisco Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request. This should be a valid API token with sufficient permissions to read device liveTools information.

.PARAMETER Serial
The serial number of the target Meraki device. The device must exist in the organization accessible by the provided API token.

.PARAMETER LedsBlinkID
The identifier for the specific "leds blink" liveTools action to retrieve. This corresponds to the blink action ID as exposed by the Meraki liveTools API.

.EXAMPLE
# Using a literal API key and device identifiers
Get-MerakiDeviceLiveToolsLedsBlink -AuthToken '0123456789abcdef' -Serial 'Q2XX-XXXX-XXXX' -LedsBlinkID '1'

.EXAMPLE
# Using variables
$token = Get-Secret -Name MerakiApiKey
$DeviceSerial = 'Q2XX-XXXX-XXXX'
$blinkId = '1'
Get-MerakiDeviceLiveToolsLedsBlink -AuthToken $token -Serial $DeviceSerial -LedsBlinkID $blinkId

.NOTES
- Requires network connectivity to api.meraki.com.
- Ensure the AuthToken has appropriate Dashboard API permissions for the target organization and device.
- The function issues an HTTPS GET to: https://api.meraki.com/api/v1/devices/{serial}/liveTools/leds/blink/{ledsBlinkId}
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$LedsBlinkID
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/leds/blink/$LedsBlinkID"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
