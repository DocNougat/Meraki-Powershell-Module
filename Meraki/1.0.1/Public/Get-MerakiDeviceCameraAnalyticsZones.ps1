function Get-MerakiDeviceCameraAnalyticsZones {
    <#
    .SYNOPSIS
        Gets a list of analytic zones for a specific camera device by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve a list of analytic zones configured for a specific camera device, based on its serial number.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera device to retrieve analytic zones for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraAnalyticsZones -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns a list of analytic zones configured for the Cisco Meraki camera device with the specified serial number.
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
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/analytics/zones" -Header $header
        return $response
    }
    catch {
        Write-Error "Failed to retrieve Meraki camera analytic zones: $_"
    }
}
