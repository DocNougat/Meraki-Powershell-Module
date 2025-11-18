function Get-MerakiDeviceLiveToolsMacTable {
<#
.SYNOPSIS
Retrieves a MAC table entry from the Live Tools macTable for a specified Meraki device.

.DESCRIPTION
Get-MerakiDeviceLiveToolsMacTable calls the Meraki Dashboard API to fetch details for a specific macTable entry on a device's Live Tools endpoint. The function uses the provided dashboard API key and device serial to build the request and returns the deserialized JSON response from Invoke-RestMethod.

.PARAMETER AuthToken
The Meraki Dashboard API key used to authenticate the request. Provide a valid API key with the necessary permissions to read device live tools data.

.PARAMETER Serial
The serial number of the Meraki device for which the Live Tools macTable entry will be retrieved.

.PARAMETER macTableID
The identifier of the macTable entry to retrieve (as provided by the device Live Tools macTable endpoint).

.EXAMPLE
# Retrieve a specific macTable entry for device serial ABCDEF-12345
Get-MerakiDeviceLiveToolsMacTable -AuthToken 'XXXXXXXXXXXXXXXXXXXX' -Serial 'ABCDEF-12345' -macTableID '42'

.EXAMPLE
# Store the result for further processing
$entry = Get-MerakiDeviceLiveToolsMacTable -AuthToken $env:MERAKI_API_KEY -Serial 'QWERTY-67890' -macTableID 'abc123'
$entry | Format-List

.NOTES
- Ensure the AuthToken has sufficient privileges to access device live tools data.
- On HTTP or network errors, the function throws a terminating error (propagates the caught exception).
- This targets the Meraki Dashboard API v1.

.LINK
https://developer.cisco.com/meraki/api-v1/
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$macTableID
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/macTable/$macTableID"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
