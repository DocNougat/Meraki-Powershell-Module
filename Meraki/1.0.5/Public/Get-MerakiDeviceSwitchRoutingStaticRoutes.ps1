function Get-MerakiDeviceSwitchRoutingStaticRoutes {
    <#
    .SYNOPSIS
    Gets a list of static routes configured on a Meraki switch device.

    .DESCRIPTION
    The Get-MerakiDeviceSwitchRoutingStaticRoutes function retrieves a list of static routes that are configured on a specific Meraki switch device.

    .PARAMETER AuthToken
    The API key for the Meraki Dashboard.

    .PARAMETER deviceSerial
    The serial number of the Meraki switch device.

    .EXAMPLE
    PS C:\> Get-MerakiDeviceSwitchRoutingStaticRoutes -AuthToken "1234" -deviceSerial "ABCD"

    This example retrieves a list of static routes for the Meraki switch device with serial number "ABCD", using the API key "1234".

    .NOTES
    For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
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

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/staticRoutes" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
