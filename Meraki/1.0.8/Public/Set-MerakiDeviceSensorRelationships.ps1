function Set-MerakiDeviceSensorRelationships {
    <#
    .SYNOPSIS
    Updates the sensor relationships for a Meraki device.
    
    .DESCRIPTION
    The Set-MerakiDeviceSensorRelationships function allows you to update the sensor relationships for a specified Meraki device by providing the authentication token, device serial number, and a string of related devices.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the Meraki device for which you want to update the sensor relationships.
    
    .PARAMETER SensorRelationships
    A string of related devices for the role.
    
    .EXAMPLE
    $config = [PSCustomObject]@{
        livestream = @{
            relatedDevices = @(
                @{
                    serial = "Q2XX-XXXX-XXXX"
                },
                @{
                    serial = "Q4XX-XXXX-XXXX"
                }
            )
        }
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiDeviceSensorRelationships -AuthToken "your-api-token" -Serial "1234" -SensorRelationships $config

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
            [string]$SensorRelationships
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$Serial/sensor/relationships"
    
            $body = $SensorRelationships
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }