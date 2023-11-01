function Get-MerakiDeviceSwitchPortsStatusesPackets {
    <#
    .SYNOPSIS
    Gets the packet counters for all the ports of a switch device, along with their statuses.
    
    .DESCRIPTION
    This function retrieves the packet counters for all the ports of a switch device, along with their statuses, for the specified timespan. If the timespan is not specified, the function retrieves data for the last 30 minutes.
    
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    
    .PARAMETER deviceSerial
    The serial number of the Meraki switch device.
    
    .PARAMETER t0
    The beginning of the timespan for which data should be fetched. The value should be in ISO 8601 format (e.g. 2018-11-30T23:00:00Z). If not specified, data for the last 30 minutes will be fetched.
    
    .PARAMETER timespan
    The timespan for which data should be fetched, in seconds. If not specified, data for the last 30 minutes will be fetched.
    
    .EXAMPLE
    PS C:\> Get-MerakiDeviceSwitchPortsStatusesPackets -AuthToken '12345' -deviceSerial 'Q234-ABCD-5678' -timespan 3600
    
    This command retrieves the packet counters for all the ports of the switch device with serial number Q234-ABCD-5678 for the last hour.
    
    .NOTES
    For more information, see the Meraki Dashboard API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-device-switch-ports-statuses-packets
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null
    )
    
    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
    }
    
    $queryParams = @{}
    
    if ($timespan) {
        $queryParams['timespan'] = $timespan
    } else {
        if ($t0) {
            $queryParams['t0'] = $t0
        }
    }
    
    $queryString = New-MerakiQueryString -queryParams $queryParams
    
    $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/ports/statuses/packets?$queryString"
    
    try {
        $URI = [uri]::EscapeUriString($URL)
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}