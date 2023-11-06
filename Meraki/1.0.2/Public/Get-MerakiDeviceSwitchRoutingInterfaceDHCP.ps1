function Get-MerakiDeviceSwitchRoutingInterfaceDHCP {
    <#
    .SYNOPSIS
    Retrieves the DHCP settings for a specified routing interface of a Meraki switch device.

    .DESCRIPTION
    The Get-MerakiDeviceSwitchRoutingInterfaceDHCP function retrieves the DHCP settings for a specified routing interface of a Meraki switch device. The function requires an authentication token and the serial number of the switch device. You must also specify the ID of the routing interface whose DHCP settings you want to retrieve.

    .PARAMETER AuthToken
    Specifies the Meraki Dashboard API token used to authenticate the API request.

    .PARAMETER deviceSerial
    Specifies the serial number of the Meraki switch device whose routing interface DHCP settings you want to retrieve.

    .PARAMETER interfaceId
    Specifies the ID of the routing interface whose DHCP settings you want to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiDeviceSwitchRoutingInterfaceDHCP -AuthToken "1234" -deviceSerial "Q2HY-XXXX-XXXX" -interfaceId "1234"

    This command retrieves the DHCP settings for the routing interface with ID "1234" on the Meraki switch device with serial number "Q2HY-XXXX-XXXX", using the specified authentication token.

    .NOTES
    For more information on the Meraki Dashboard API, visit:
    https://developer.cisco.com/meraki/api-v1/
    #>

    [CmdletBinding()]
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/interfaces/$interfaceId/dhcp" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error "Error occurred while retrieving the DHCP settings for routing interface $interfaceId on switch device $DeviceSerial. More information: $_"
        return $null
    }
}
