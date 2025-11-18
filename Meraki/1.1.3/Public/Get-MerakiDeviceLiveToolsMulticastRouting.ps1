function Get-MerakiDeviceLiveToolsMulticastRouting {
<#
.SYNOPSIS
Retrieves multicast routing configuration for a specific device's Live Tools entry.

.DESCRIPTION
Get-MerakiDeviceLiveToolsMulticastRouting calls the Meraki Dashboard API to fetch the multicast routing entry
identified by multicastRoutingID for the device with the given serial number. The function performs an HTTP GET
against the device liveTools multicastRouting resource and returns the response deserialized as a PowerShell object.

.PARAMETER AuthToken
The Meraki API key used for authentication. This should be supplied as a secure string in production scripts
and must be kept confidential. The key is sent via the X-Cisco-Meraki-API-Key request header.

.PARAMETER Serial
The device serial number (string) for the target Meraki device whose Live Tools multicast routing entry will be retrieved.

.PARAMETER multicastRoutingID
The identifier of the multicast routing entry to retrieve (string). This corresponds to the specific Live Tools
multicastRouting resource on the device.

.EXAMPLE
# Retrieve a multicast routing entry for device serial Q2XX-XXXX-XXXX
$apiKey = "0123456789abcdef0123456789abcdef"
Get-MerakiDeviceLiveToolsMulticastRouting -AuthToken $apiKey -Serial "Q2XX-XXXX-XXXX" -multicastRoutingID "abc123"

.EXAMPLE
# Using pipeline to pass serial and ID from variables
$DeviceSerial = "Q2XX-XXXX-XXXX"
$entryId = "abc123"
Get-MerakiDeviceLiveToolsMulticastRouting -AuthToken $apiKey -Serial $DeviceSerial -multicastRoutingID $entryId

.NOTES
- This function issues an HTTP GET to the Meraki Dashboard API endpoint:
    https://api.meraki.com/api/v1/devices/{serial}/liveTools/multicastRouting/{multicastRoutingID}
- Errors from the REST call are thrown; callers may wish to wrap calls in try/catch to handle API or network errors.

.LINK
https://developer.cisco.com/meraki/api-v1/#!get-device-live-tools-multicast-routing
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$multicastRoutingID
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/multicastRouting/$multicastRoutingID"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
