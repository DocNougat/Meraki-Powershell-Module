function Set-MerakiNetworkWirelessBluetoothSettings {
    <#
    .SYNOPSIS
    Updates a network wireless Bluetooth settings.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessBluetoothSettings function allows you to update a network wireless Bluetooth settings by providing the authentication token, network ID, and a JSON formatted string of the Bluetooth configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER BluetoothConfig
    A JSON formatted string of the Bluetooth configuration.
    
    .EXAMPLE
    $BluetoothConfig = [PSCustomObject]@{
        scanningEnabled = $true
        advertisingEnabled = $true
        uuid = "00000000-0000-0000-000-000000000000"
        majorMinorAssignmentMode = "Non-unique"
        major = 1
        minor = 1
    }
    $BluetoothConfig = $BluetoothConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessBluetoothSettings -AuthToken "your-api-token" -NetworkId "1234" -BluetoothConfig $BluetoothConfig
    
    This example updates a network wireless Bluetooth settings with the specified configuration.
    
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
            [string]$BluetoothConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/bluetooth/settings"
    
            $body = $BluetoothConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }