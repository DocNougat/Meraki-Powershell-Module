function Get-MerakiDeviceCameraSense {
    <#
    .SYNOPSIS
        Gets the camera sense configuration for a specific Cisco Meraki device by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve the camera sense configuration for a specific Cisco Meraki device, based on its serial number. The function returns detailed information about the current camera sense settings, including object detection models and parameters.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki device to retrieve camera sense configuration for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraSense -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns the camera sense configuration for the Cisco Meraki device with the specified serial number.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/sense" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
