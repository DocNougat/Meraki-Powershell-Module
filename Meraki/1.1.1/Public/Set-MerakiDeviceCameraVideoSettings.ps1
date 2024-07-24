function Set-MerakiDeviceCameraVideoSettings {
    <#
    .SYNOPSIS
    Updates the camera video settings for a Meraki device.
    
    .DESCRIPTION
    The Set-MerakiDeviceCameraVideoSettings function allows you to update the camera video settings for a specified Meraki device by providing the authentication token, device serial number, and a boolean indicating if external RTSP stream is exposed.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device for which you want to update the camera video settings.
    
    .PARAMETER ExternalRtspEnabled
    A boolean indicating if external RTSP stream is exposed.
    
    .EXAMPLE
    Set-MerakiDeviceCameraVideoSettings -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -ExternalRtspEnabled $true
    
    This example updates the camera video settings for the Meraki device with serial number "Q2GV-ABCD-1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$Serial,
            [parameter(Mandatory=$true)]
            [bool]$ExternalRtspEnabled
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/camera/video/settings"
    
            $body = @{
                "externalRtspEnabled" = $ExternalRtspEnabled
            } | ConvertTo-Json
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }