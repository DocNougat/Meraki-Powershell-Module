<#
.SYNOPSIS
Retrieves sensor relationship information for a specified Meraki device.

.DESCRIPTION
Calls the Meraki Dashboard API endpoint GET /devices/{serial}/sensor/relationships to fetch relationships for sensors associated with a device identified by its serial number. The function returns the deserialized JSON response from the API (typically a PSCustomObject or array of objects). HTTP or network errors will throw terminating exceptions.

.PARAMETER AuthToken
The Meraki Dashboard API key (X-Cisco-Meraki-API-Key). Provide a valid API token with sufficient privileges to read device sensor information. This parameter is mandatory.

.PARAMETER Serial
The serial number of the Meraki device whose sensor relationships should be retrieved. This parameter is mandatory.

.EXAMPLE
# Send output to the pipeline for further processing
Get-MerakiDeviceSensorRelationships -AuthToken $token -Serial $DeviceSerial | Where-Object { $_.type -eq 'sensor' }

.LINK
https://developer.cisco.com/meraki/api-v1/#!get-device-sensor-relationships
#>
function Get-MerakiDeviceSensorRelationships {
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

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/sensor/relationships"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
