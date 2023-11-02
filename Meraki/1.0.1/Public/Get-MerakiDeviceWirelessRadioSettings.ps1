function Get-MerakiDeviceWirelessRadioSettings {
    <#
    .SYNOPSIS
    Gets the radio settings of a wireless device.
    
    .DESCRIPTION
    The Get-MerakiDeviceWirelessRadioSettings function retrieves the radio settings of a specified wireless device from the Meraki dashboard using the Meraki API. 
    
    .PARAMETER AuthToken
    The Meraki API token used to authenticate to the Meraki dashboard.
    
    .PARAMETER deviceSerial
    The serial number of the Meraki device.
    
    .EXAMPLE
    PS C:\> Get-MerakiDeviceWirelessRadioSettings -AuthToken '12345' -deviceSerial 'ABCD-1234-EFGH'
    
    This command retrieves the radio settings of the Meraki device with the specified serial number.
    
    .NOTES
    For more information about the Meraki API and available endpoints, see the Meraki API documentation: https://developer.cisco.com/meraki/api/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/radio/settings" -Header $header
        return $response
    }
    catch {
        Write-Host "Error: $($Error[0].Exception.Message)"
    }
}
