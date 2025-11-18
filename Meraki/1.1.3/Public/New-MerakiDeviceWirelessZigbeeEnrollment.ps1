function New-MerakiDeviceWirelessZigbeeEnrollment {
<#
.SYNOPSIS
Creates a Zigbee enrollment for a specified Meraki wireless device.

.DESCRIPTION
New-MerakiDeviceWirelessZigbeeEnrollment calls the Cisco Meraki Dashboard API endpoint to create a new Zigbee enrollment for the given device serial number. The function performs an HTTP POST to the /devices/{serial}/wireless/zigbee/enrollments endpoint using the provided API key in the X-Cisco-Meraki-API-Key header and returns the deserialized API response.

.PARAMETER AuthToken
The Meraki API key used for authentication (sent as X-Cisco-Meraki-API-Key). This key must have sufficient privileges to manage device Zigbee enrollments. Keep API keys secret and avoid storing them in plain text.

.PARAMETER DeviceSerial
The serial number of the Meraki device for which to create the Zigbee enrollment (for example: "Q2XX-XXXX-XXXX").

.EXAMPLE
# Create an enrollment and display the returned object
$apiKey = "0123456789abcdef0123456789abcdef01234567"
$response = New-MerakiDeviceWirelessZigbeeEnrollment -AuthToken $apiKey -DeviceSerial "Q2XX-XXXX-XXXX"
$response | Format-List *

.NOTES
- Endpoint used: POST https://api.meraki.com/api/v1/devices/{serial}/wireless/zigbee/enrollments
- Headers set: X-Cisco-Meraki-API-Key and Content-Type: application/json; charset=utf-8
- The function sets a User-Agent of "MerakiPowerShellModule/1.1.3 DocNougat".
- Invoke-RestMethod errors are rethrown; callers should use try/catch to handle API errors and HTTP failures.
- Ensure network connectivity to api.meraki.com and that the provided API key has the required permissions.

.LINK
https://developer.cisco.com/meraki/api-v1/  # Meraki Dashboard API documentation
#>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/zigbee/enrollments"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }