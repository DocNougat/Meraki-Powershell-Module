function Get-MerakiDeviceCameraVideoSettings {
    <#
    .SYNOPSIS
        Gets the video settings of a specific Cisco Meraki camera by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve information about the video settings of a specific Cisco Meraki camera, based on its serial number. The function returns detailed information about the video settings, including resolution, frame rate, quality, and orientation.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera to retrieve video settings for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraVideoSettings -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns information about the video settings of the Cisco Meraki camera with the specified serial number.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/video/settings" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error "Failed to retrieve Meraki camera video settings: $_"
    }
}
