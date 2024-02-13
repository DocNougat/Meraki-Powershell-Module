function Get-MerakiDeviceAppliancePerformance {
    <#
    .SYNOPSIS
        Gets performance information for a specific Cisco Meraki appliance by serial number.
    .DESCRIPTION
        This function makes a REST API call to the Meraki dashboard API to retrieve performance information for a specific Cisco Meraki appliance, based on its serial number. The function returns detailed information about the appliance's CPU usage, memory usage, and WAN uplink usage.
    .PARAMETER AuthToken
        The authentication token to use for the API call. This should be a valid API key for the Meraki dashboard.
    .PARAMETER deviceSerial
        The serial number of the Cisco Meraki appliance to retrieve performance information for.
    .EXAMPLE
        PS C:\> Get-MerakiDeviceAppliancePerformance -AuthToken "myapikey" -deviceSerial "Q2XX-XXXX-XXXX"
        Returns performance information for the Cisco Meraki appliance with the specified serial number.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/devices/$DeviceSerial/appliance/performance" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}