function Get-MerakiDeviceSwitchPort {
    <#
.SYNOPSIS
Retrieves the configuration of a switch port on a Meraki device.

.DESCRIPTION
This function retrieves the configuration of a switch port on a Meraki device. 
You need to provide the Meraki API key, the device serial number and the port ID.

.PARAMETER AuthToken
The Meraki API key to use for the request.

.PARAMETER deviceSerial
The serial number of the Meraki device.

.PARAMETER portID
The ID of the switch port to retrieve configuration for.

.EXAMPLE
Get-MerakiDeviceSwitchPort -AuthToken 'YourAPIKey' -deviceSerial 'Q2XX-XXXX-XXXX' -portID 4

This example retrieves the configuration of switch port 4 on the Meraki device with serial number 'Q2XX-XXXX-XXXX'.

.NOTES
For more information on the API endpoint, please see:
https://developer.cisco.com/meraki/api/#!get-device-switch-port
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, HelpMessage="The Meraki API key to use for the request.")]
        [string]$AuthToken,
        [parameter(Mandatory=$true, HelpMessage="The serial number of the Meraki device.")]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true, HelpMessage="The ID of the switch port to retrieve configuration for.")]
        [string]$portID
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $uri = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/ports/$portID"
        $response = Invoke-RestMethod -Method Get -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
