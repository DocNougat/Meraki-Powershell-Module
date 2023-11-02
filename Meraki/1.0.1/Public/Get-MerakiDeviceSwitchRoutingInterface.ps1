function Get-MerakiDeviceSwitchRoutingInterface {
    <#
    .SYNOPSIS
    Retrieves information about a specific routing interface on a Meraki switch device.

    .DESCRIPTION
    This function uses the Meraki Dashboard API to retrieve information about a specific routing interface on a Meraki switch device.

    .PARAMETER AuthToken
    The API authorization token provided by Meraki.

    .PARAMETER deviceSerial
    The serial number of the Meraki device.

    .PARAMETER interfaceId
    The ID of the routing interface to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiDeviceSwitchRoutingInterface -AuthToken "1234" -deviceSerial "ABC123" -interfaceId "1"

    Retrieves information about the routing interface with ID "1" on the Meraki device with serial number "ABC123".

    .NOTES
    For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
    #>

    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$interfaceId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/interfaces/$interfaceId" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}