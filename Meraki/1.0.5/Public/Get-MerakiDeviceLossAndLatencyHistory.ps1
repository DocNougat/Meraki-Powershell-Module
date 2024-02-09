function Get-MerakiDeviceLossAndLatencyHistory {
    <#
    .SYNOPSIS
    Get the loss and latency history of a Meraki device.

    .DESCRIPTION
    This function retrieves the loss and latency history of a Meraki device. The history data can be filtered by time range, resolution, uplink, and IP address.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER serial
    The serial number of the Meraki device.

    .PARAMETER t0
    The beginning of the time range to query.

    .PARAMETER t1
    The end of the time range to query.

    .PARAMETER timespan
    The timespan for which the information will be fetched. The value should be in seconds.

    .PARAMETER resolution
    The time resolution in seconds for returned data.

    .PARAMETER uplink
    The WAN uplink for which to show the loss and latency data.

    .PARAMETER ip
    The IP address for which to show the loss and latency data.

    .EXAMPLE
    Get-MerakiDeviceLossAndLatencyHistory -AuthToken $AuthToken -serial "Q234-ABCD-5678" -t0 "2022-03-01T00:00:00Z" -t1 "2022-03-02T00:00:00Z" -resolution 300 -uplink "wan1"

    This example retrieves the loss and latency history of the Meraki device with serial number "Q234-ABCD-5678" for the time range between March 1st and March 2nd of 2022, with a resolution of 300 seconds and WAN uplink "wan1".

    .EXAMPLE
    Get-MerakiDeviceLossAndLatencyHistory -AuthToken $AuthToken -serial "Q234-ABCD-5678" -timespan 86400 -ip "192.168.1.10"

    This example retrieves the loss and latency history of the Meraki device with serial number "Q234-ABCD-5678" for the last 24 hours, with data filtered by IP address "192.168.1.10".

    .INPUTS
    None.

    .OUTPUTS
    The function returns the loss and latency history of the specified Meraki device.

    .NOTES
    This function requires the New-MerakiQueryString function to be defined in the same script or module.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$serial,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$resolution = $null,
        [parameter(Mandatory=$false)]
        [string]$uplink = $null,
        [parameter(Mandatory=$true)]
        [string]$ip = $null
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
            if ($t1) {
                $queryParams['t1'] = $t1
            }
        }
        if ($resolution) {
            $queryParams['resolution'] = $resolution
        }
        if ($uplink) {
            $queryParams['uplink'] = $uplink
        }
        if ($ip) {
            $queryParams['ip'] = $ip
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URI = "https://api.meraki.com/api/v1/devices/$serial/lossAndLatencyHistory?$queryString"
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}