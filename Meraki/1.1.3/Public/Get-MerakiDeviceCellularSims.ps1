function Get-MerakiDeviceCellularSims {
    <#
    .SYNOPSIS
    Get the list of SIMs for a specific Meraki cellular gateway device.

    .DESCRIPTION
    This function retrieves the list of SIMs for a specific Meraki cellular gateway device using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The authorization token for the Meraki Dashboard API.
    
    .PARAMETER deviceSerial
    The serial number of the Meraki cellular gateway device.
    
    .EXAMPLE
    PS C:\> Get-MerakiDeviceCellularSims -AuthToken "1234" -deviceSerial "ABCD"
    
    This example retrieves the list of SIMs for the Meraki cellular gateway device with serial number "ABCD" using the authorization token "1234".
    
    .NOTES
    For more information about the Meraki Dashboard API, see the official documentation at https://developer.cisco.com/meraki/api-v1/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/cellular/sims" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
