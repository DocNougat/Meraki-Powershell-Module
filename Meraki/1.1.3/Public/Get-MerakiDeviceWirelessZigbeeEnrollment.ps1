function Get-MerakiDeviceWirelessZigbeeEnrollment {
<#
.SYNOPSIS
Retrieves a Zigbee enrollment record for a specific Meraki device.

.DESCRIPTION
Get-MerakiDeviceWirelessZigbeeEnrollment calls the Meraki Dashboard API to fetch details about a specific Zigbee enrollment associated with a device serial. The function performs an authenticated GET request to the /devices/{serial}/wireless/zigbee/enrollments/{enrollmentId} endpoint and returns the enrollment information as a PowerShell object.

.PARAMETER AuthToken
The Meraki Dashboard API key used for authentication. Provide a valid API key with permissions to read device configuration and wireless/zigbee enrollment data.

.PARAMETER DeviceSerial
The serial number of the Meraki device for which the Zigbee enrollment is being requested. This should be a valid device serial present in your Meraki organization.

.PARAMETER ZigbeeEnrollmentId
The identifier of the Zigbee enrollment record to retrieve. Provide the enrollment ID returned by the Meraki API when the enrollment was created or listed.

.EXAMPLE
# Store the returned object and inspect properties
$enrollment = Get-MerakiDeviceWirelessZigbeeEnrollment -AuthToken $token -DeviceSerial $serial -ZigbeeEnrollmentId $enrollmentId
$enrollment | Format-List *
#>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$ZigbeeEnrollmentId
    )

    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
    }

    $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/zigbee/enrollments/$ZigbeeEnrollmentId"

    $URI = [uri]::EscapeUriString($URL)

    try {
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
