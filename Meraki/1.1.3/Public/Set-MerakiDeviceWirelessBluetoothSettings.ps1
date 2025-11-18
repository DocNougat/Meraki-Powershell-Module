function Set-MerakiDeviceWirelessBluetoothSettings {
    <#
    .SYNOPSIS
    Updates a device wireless Bluetooth settings.
    
    .DESCRIPTION
    The Set-MerakiDeviceWirelessBluetoothSettings function allows you to update a device wireless Bluetooth settings by providing the authentication token, device serial number, and a JSON formatted string of the Bluetooth configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER Serial
    The serial number of the device.
    
    .PARAMETER BluetoothConfig
    A JSON formatted string of the Bluetooth configuration.
    
    .EXAMPLE
    $BluetoothConfig = [PSCustomObject]@{
        uuid = "00000000-0000-0000-000-000000000000"
        major = 13
        minor = 125
    }

    $BluetoothConfig = $BluetoothConfig | ConvertTo-Json -Compress -Depth 4
    Set-MerakiDeviceWirelessBluetoothSettings -AuthToken "your-api-token" -Serial "Q234-ABCD-0001" -BluetoothConfig $BluetoothConfig

    This example updates a device wireless Bluetooth settings with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial,
            [parameter(Mandatory=$true)]
            [string]$BluetoothConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/bluetooth/settings"
    
            $body = $BluetoothConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }