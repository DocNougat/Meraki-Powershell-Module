function Get-MerakiDeviceCameraQualityAndRetention {
    <#
    .SYNOPSIS
        Gets the quality and retention settings for a specific camera device by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve information about the quality and retention settings for a specific Cisco Meraki camera device, based on its serial number. The function returns detailed information about the camera's quality and retention settings, including the resolution, bitrate, and maximum duration of video recordings.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera device to retrieve quality and retention settings for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraQualityAndRetention -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns information about the quality and retention settings for the Cisco Meraki camera device with the specified serial number.
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
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/qualityAndRetention" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
