function Set-MerakiDeviceSwitchWarmSpare {
    <#
    .SYNOPSIS
    Updates a device switch warm spare.
    
    .DESCRIPTION
    The Set-MerakiDeviceSwitchWarmSpare function allows you to update a device switch warm spare by providing the authentication token, device serial number, and a JSON formatted string of the warm spare configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the device.
    
    .PARAMETER SpareConfig
    A JSON formatted string of the warm spare configuration.
    
    .EXAMPLE
    $SpareConfig = [PSCustomObject]@{
        enabled = $true
        spareSerial = "Q234-ABCD-0002"
    }

    $SpareConfig = $SpareConfig | ConvertTo-Json -Compress
    Set-MerakiDeviceSwitchWarmSpare -AuthToken "your-api-token" -Serial "Q234-ABCD-0001" -SpareConfig $SpareConfig

    This example updates a device switch warm spare with the specified configuration.
    
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
            [string]$SpareConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/switch/warmSpare"
    
            $body = $SpareConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }