function New-MerakiDeviceLiveToolsMulticastRouting {
<#
.SYNOPSIS
Creates or updates multicast routing settings for a Meraki device's Live Tools via the Meraki Dashboard API.

.DESCRIPTION
This function sends a POST request to the Meraki Dashboard API endpoint for device Live Tools multicast routing.
It requires an API key and the device serial number. The request body must be provided as a JSON-formatted string
in the callbackJson parameter and should follow the payload schema expected by the Meraki API for multicast routing.

.PARAMETER AuthToken
The Meraki API key used for authentication. Provide a valid API key with sufficient permissions to modify device Live Tools settings.
Type: String
Required: True

.PARAMETER Serial
The serial number of the Meraki device for which multicast routing settings will be created or updated.
Type: String
Required: True

.PARAMETER callbackJson
A JSON-formatted string containing the multicast routing configuration to send in the request body.
This should conform to the Meraki API's expected schema for the /devices/{serial}/liveTools/multicastRouting endpoint.
Type: String
Required: False

.EXAMPLE
# Basic usage
$apiKey = "1234567890abcdef"
$DeviceSerial = "Q2XX-XXXX-XXXX"
New-MerakiDeviceLiveToolsMulticastRouting -AuthToken $apiKey -Serial $DeviceSerial

.NOTES
- The function sets the "X-Cisco-Meraki-API-Key" header for authentication and posts the provided JSON to the endpoint:
  https://api.meraki.com/api/v1/devices/{serial}/liveTools/multicastRouting
- Errors encountered during the request are written to debug stream and re-thrown to the caller.
- Ensure the provided API key has the appropriate scope/permissions for the target organization and device.

.LINK
Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api
#>    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string]$callbackJson
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/multicastRouting"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $callbackJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}