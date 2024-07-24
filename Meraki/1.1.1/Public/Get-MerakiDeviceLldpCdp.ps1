function Get-MerakiDeviceLldpCdp {
    <#
    .SYNOPSIS
    Retrieves the LLDP and CDP information for a specified device.

    .DESCRIPTION
    The Get-MerakiDeviceLldpCdp function retrieves the LLDP and CDP information for a specified device.

    .PARAMETER AuthToken
    Specifies the Meraki Dashboard API token.

    .PARAMETER deviceSerial
    Specifies the serial number of the device.

    .EXAMPLE
    Get-MerakiDeviceLldpCdp -AuthToken '12345' -deviceSerial 'Q2FD-4ER7-RTY9'

    This command retrieves the LLDP and CDP information for the device with the specified serial number using the specified Meraki Dashboard API token.

    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/lldpCdp" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
