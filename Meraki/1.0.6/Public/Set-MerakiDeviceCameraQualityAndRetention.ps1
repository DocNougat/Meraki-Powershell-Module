function Set-MerakiDeviceCameraQualityAndRetention {
    <#
    .SYNOPSIS
    Updates the quality and retention settings of a Meraki device's camera.
    
    .DESCRIPTION
    The Set-MerakiDeviceCameraQualityAndRetention function allows you to update the quality and retention settings of a Meraki device's camera by providing the authentication token, device serial, and a JSON configuration for the settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the device for which you want to update the settings.
    
    .PARAMETER QualityAndRetentionConfig
    The JSON configuration for the quality and retention settings to be updated. Refer to the JSON schema for required parameters and their format.
    
    .EXAMPLE
    $QualityAndRetentionConfig = [PSCustomObject]@{
        motionBasedRetentionEnabled = $false
        audioRecordingEnabled = $false
        restrictedBandwidthModeEnabled = $false
        profileId = "1234"
        quality = "Standard"
        motionDetectorVersion = 2
        resolution = "1280x720"
    }

    $QualityAndRetentionConfig = $QualityAndRetentionConfig | ConvertTo-Json -Compress

    Set-MerakiDeviceCameraQualityAndRetention -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -QualityAndRetentionConfig $QualityAndRetentionConfig

    This example updates the quality and retention settings of the Meraki device's camera with serial "Q2GV-ABCD-1234".
    
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
            [string]$QualityAndRetentionConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $QualityAndRetentionConfig
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/camera/qualityAndRetention"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }