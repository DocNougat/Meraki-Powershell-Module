function Get-MerakiDeviceCameraAnalyticsLive {
    <#
    .SYNOPSIS
        Gets live analytics data for a specific Cisco Meraki camera by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve live analytics data for a specific Cisco Meraki camera, based on its serial number. The function returns detailed information about the camera's live analytics data, including the number of people detected and the average age and gender of those detected.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera to retrieve live analytics data for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraAnalyticsLive -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns live analytics data for the Cisco Meraki camera with the specified serial number.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/analytics/live" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
