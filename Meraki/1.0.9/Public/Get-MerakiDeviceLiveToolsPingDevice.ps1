function Get-MerakiDeviceLiveToolsPingDevice {
        <#
        .SYNOPSIS
        Retrieves the results of a ping to a specified IP address from a device's LAN interface.

        .DESCRIPTION
        Retrieves the results of a ping to a specified IP address from a device's LAN interface. The result includes information about the ping itself, such as the packet loss percentage and the time it took for the ping to complete.

        .PARAMETER AuthToken
        The Meraki Dashboard API authentication token.

        .PARAMETER pingId
        The ID of the ping request.

        .PARAMETER deviceSerial
        The serial number of the device.

        .EXAMPLE
        Get-MerakiDeviceLiveToolsPingDevice -AuthToken "1234" -pingId "5678" -deviceSerial "ABC123"

        This example retrieves the results of a ping to a specified IP address from a device's LAN interface.

        .NOTES
        For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
        #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$pingId,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/pingDevice/$pingId" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
