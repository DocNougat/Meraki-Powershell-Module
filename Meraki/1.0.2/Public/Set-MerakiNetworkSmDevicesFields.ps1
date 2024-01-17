function Set-MerakiNetworkSmDevicesFields {
    <#
    .SYNOPSIS
    Updates the fields of a device in a Meraki network.
    
    .DESCRIPTION
    The Set-MerakiNetworkSmDevicesFields function allows you to update the fields of a device in a specified Meraki network by providing the authentication token, network ID, and a JSON formatted string of device fields configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network in which the device is located.
    
    .PARAMETER DeviceFieldsConfig
    A JSON formatted string of device fields configuration.
    
    .EXAMPLE
    $deviceFieldsConfig = [PSCustomObject]@{
        wifiMac = "00:11:22:33:44:55"
        id = "1284392014819"
        serial = "Q234-ABCD-5678"
        deviceFields = [PSCustomObject]@{
            name = "Miles's phone"
            notes = "Here's some info about my device"
        }
    }

    $deviceFieldsConfig = $deviceFieldsConfig | ConvertTo-Json
    Set-MerakiNetworkSmDevicesFields -AuthToken "your-api-token" -NetworkId "1234" -DeviceFieldsConfig $deviceFieldsConfig

    This example updates the fields of a device in the Meraki network with ID "1234" with the specified device fields configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$DeviceFieldsConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/fields"
    
            $body = $DeviceFieldsConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }