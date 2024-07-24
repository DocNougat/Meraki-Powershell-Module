function Get-MerakiDeviceWirelessBluetoothSettings {
    <#
    .SYNOPSIS
    Retrieves the Bluetooth settings for a given Meraki wireless device.

    .DESCRIPTION
    This function retrieves the Bluetooth settings for a specified Meraki wireless device using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER deviceSerial
    The serial number of the Meraki wireless device.

    .EXAMPLE
    PS C:\> Get-MerakiDeviceWirelessBluetoothSettings -AuthToken "myAuthToken" -deviceSerial "myDeviceSerial"
    
    Returns the Bluetooth settings for the specified Meraki wireless device.

    .NOTES
    For more information about the Meraki Dashboard API, please see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/bluetooth/settings" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    } 
    catch {
        Write-Debug $_
        Throw $_
    }
}