function Set-MerakiDeviceCameraSense {
    <#
    .SYNOPSIS
    Updates the camera sense settings for a Meraki device.
    
    .DESCRIPTION
    The Set-MerakiDeviceCameraSense function allows you to update the camera sense settings for a specified Meraki device by providing the authentication token, device serial number, and a camera sense configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device for which you want to update the camera sense settings.
    
    .PARAMETER CameraSenseConfig
    A string containing the camera sense configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $CameraSenseConfig = '{
        "senseEnabled": true,
        "audioDetection": { "enabled": false },
        "mqttBrokerId": "1234"
    }'
    $CameraSenseConfig = $CameraSenseConfig | ConvertTo-Json -Compress
    
    Set-MerakiDeviceCameraSense -AuthToken "your-api-token" -Serial "Q2GV-ABCD-1234" -CameraSenseConfig $CameraSenseConfig
    
    This example updates the camera sense settings for the Meraki device with serial number "Q2GV-ABCD-1234".
    
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
            [string]$CameraSenseConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/camera/sense"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -Body $CameraSenseConfig
            return $response
        }
        catch {
            Write-Host $_
        }
    }