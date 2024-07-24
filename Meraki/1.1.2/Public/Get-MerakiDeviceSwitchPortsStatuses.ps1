function Get-MerakiDeviceSwitchPortsStatuses {
    <#
    .SYNOPSIS
    Retrieves the status for all ports of a given Meraki switch.

    .DESCRIPTION
    This function retrieves the status for all ports of a given Meraki switch. The status includes information such as link speed, duplex mode, and MAC address.

    .PARAMETER AuthToken
    The Meraki API key.

    .PARAMETER deviceSerial
    The serial number of the Meraki switch.

    .PARAMETER t0
    An optional parameter that specifies the start time for the query. It should be a UTC timestamp in ISO 8601 format (e.g., 2022-04-18T00:00:00Z).

    .PARAMETER timespan
    An optional parameter that specifies the timespan for the query in seconds. If this parameter is used, t0 will be ignored.

    .EXAMPLE
    PS C:\> Get-MerakiDeviceSwitchPortsStatuses -AuthToken "1234" -deviceSerial "Q2XX-XXXX-XXXX" -t0 "2022-04-18T00:00:00Z"

    This example retrieves the status for all ports of the Meraki switch with serial number Q2XX-XXXX-XXXX, starting at 2022-04-18T00:00:00Z.

    .NOTES
    For more information about this API endpoint, see https://developer.cisco.com/meraki/api-v1/#!get-device-switch-ports-statuses.
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
    
    try {
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
    
        $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/ports/statuses?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
