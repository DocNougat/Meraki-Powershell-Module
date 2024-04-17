function Set-MerakiDeviceCameraWirelessProfile {
    <#
    .SYNOPSIS
    Updates the camera wireless profile for a Meraki device.
    
    .DESCRIPTION
    The Set-MerakiDeviceCameraWirelessProfile function allows you to update the camera wireless profile for a specified Meraki device by providing the authentication token, device serial number, and a wireless profile configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device for which you want to update the camera wireless profile.
    
    .PARAMETER WirelessProfileConfig
    A string containing the wireless profile configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $WirelessProfileConfig = [PSCustomObject]@{
        ids = @{
            primary = "3"
            secondary = "2"
            backup = "1"
        }
    }

    $WirelessProfileConfig = $WirelessProfileConfig | ConvertTo-Json -Compress

    Set-MerakiDeviceCameraWirelessProfile -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -WirelessProfileConfig $WirelessProfileConfig

    This example updates the camera wireless profile for the Meraki device with serial number "Q2GV-ABCD-1234".
    
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
            [string]$WirelessProfileConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/camera/wirelessProfiles"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $WirelessProfileConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }