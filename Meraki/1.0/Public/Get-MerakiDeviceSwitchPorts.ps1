function Get-MerakiDeviceSwitchPorts {
    <#
.SYNOPSIS
Retrieves the list of switch ports for a specific Meraki device.

.DESCRIPTION
The Get-MerakiDeviceSwitchPorts function retrieves the list of switch ports for a specific Meraki device.

.PARAMETER AuthToken
The Meraki Dashboard API authentication token.

.PARAMETER deviceSerial
The serial number of the Meraki device.

.EXAMPLE
PS C:\> Get-MerakiDeviceSwitchPorts -AuthToken '12345' -deviceSerial 'Q2XX-XXXX-XXXX'

This command retrieves the list of switch ports for the Meraki device with the serial number 'Q2XX-XXXX-XXXX' using the authentication token '12345'.

.NOTES
For more information about the Meraki Dashboard API, visit:
https://developer.cisco.com/meraki/api-v1/
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/ports" -Header $header
        return $response
    } catch {
        Write-Error "Error retrieving switch ports: $_"
        return $null
    }
}