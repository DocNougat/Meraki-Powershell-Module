function Get-MerakiDeviceCameraSenseObjectDetectionModels {
    <#
    .SYNOPSIS
        Gets the object detection models available for a specific Cisco Meraki camera.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve information about the object detection models available for a specific Cisco Meraki camera, based on its serial number. The function returns detailed information about each available model, including its name, description, and supported object classes.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki camera to retrieve object detection models for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCameraSenseObjectDetectionModels -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns information about the object detection models available for the Cisco Meraki camera with the specified serial number.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/camera/sense/objectDetectionModels" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
