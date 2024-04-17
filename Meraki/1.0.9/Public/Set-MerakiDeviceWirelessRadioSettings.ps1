function Set-MerakiDeviceWirelessRadioSettings {
    <#
    .SYNOPSIS
    Updates a device wireless radio settings.
    
    .DESCRIPTION
    The Set-MerakiDeviceWirelessRadioSettings function allows you to update a device wireless radio settings by providing the authentication token, device serial, and a JSON formatted string of the radio settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the device.
    
    .PARAMETER RadioSettings
    A JSON formatted string of the radio settings.
    
    .EXAMPLE
    $RadioSettings = [PSCustomObject]@{
        rfProfileId = "1234"
        twoFourGhzSettings = @{
            channel = 11
            targetPower = 21
        }
        fiveGhzSettings = @{
            channel = 149
            channelWidth = 20
            targetPower = 15
        }
    }
    $RadioSettings = $RadioSettings | ConvertTo-Json
    Set-MerakiDeviceWirelessRadioSettings -AuthToken "your-api-token" -Serial "1234" -RadioSettings $RadioSettings

    This example updates a device wireless radio settings with the specified configuration.
    
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
            [string]$RadioSettings
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/wireless/radio/settings"
    
            $body = $RadioSettings
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }