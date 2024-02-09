function Get-MerakiDeviceCellularGatewayLan {
    <#
    .SYNOPSIS
        Gets the LAN settings of a specific Cisco Meraki cellular gateway by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve information about the LAN settings of a specific Cisco Meraki cellular gateway, based on its serial number. The function returns detailed information about the LAN network settings, including the IP address, subnet mask, gateway, and DNS servers.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki cellular gateway to retrieve LAN settings for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceCellularGatewayLan -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns information about the LAN settings of the Cisco Meraki cellular gateway with the specified serial number.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/cellularGateway/lan" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
