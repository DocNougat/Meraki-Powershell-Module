function Set-MerakiDeviceCameraCustomAnalytics {
    <#
    .SYNOPSIS
    Updates the custom analytics settings of a Meraki device camera.
    
    .DESCRIPTION
    The Set-MerakiDeviceCameraCustomAnalytics function allows you to update the custom analytics settings of a Meraki device camera by providing the authentication token, device serial, and a JSON configuration for the custom analytics settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device camera for which you want to update the custom analytics settings.
    
    .PARAMETER AnalyticsConfig
    The JSON configuration for the custom analytics settings to be updated. Refer to the JSON schema for required parameters and their format.
    
    .EXAMPLE
    $AnalyticsConfig = [PSCustomObject]@{
        enabled = $true
        artifactId = "1"
        parameters = @(
            @{
                name = "detection_threshold"
                value = "0.5"
            }
        )
    }

    $AnalyticsConfig = $AnalyticsConfig | ConvertTo-JSON -Compress

    Set-MerakiDeviceCameraCustomAnalytics -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -AnalyticsConfig $AnalyticsConfig

    This example updates the custom analytics settings of the Meraki device camera with serial "Q2GV-ABCD-1234".
    
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
            [string]$AnalyticsConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $body = $AnalyticsConfig
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/camera/customAnalytics"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }