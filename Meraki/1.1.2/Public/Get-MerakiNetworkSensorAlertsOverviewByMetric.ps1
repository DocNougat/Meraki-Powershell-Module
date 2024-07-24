function Get-MerakiNetworkSensorAlertsOverviewByMetric {
    <#
    .SYNOPSIS
    Retrieves an overview of sensor alerts by metric for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkSensorAlertsOverviewByMetric function retrieves an overview of sensor alerts by metric for a specified Meraki network. You can specify a timespan, start and end time, and interval for the data returned. If no timespan is specified, both start and end times must be provided.

    .PARAMETER AuthToken
    The Meraki API token for the account.

    .PARAMETER NetworkId
    The ID of the Meraki network for which to retrieve sensor alerts.

    .PARAMETER t0
    The beginning of the timespan for the data to retrieve. If no timespan is specified, both start and end times must be provided.

    .PARAMETER t1
    The end of the timespan for the data to retrieve. If no timespan is specified, both start and end times must be provided.

    .PARAMETER timespan
    The timespan for the data to retrieve, in seconds.

    .PARAMETER interval
    The time interval at which to retrieve data, in seconds.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSensorAlertsOverviewByMetric -AuthToken '12345' -NetworkId 'N_12345678' -timespan 86400 -interval 3600

    Retrieves an overview of sensor alerts by metric for the specified Meraki network over a timespan of 24 hours, with data returned every hour.

    .NOTES
    For more information, see the Meraki API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-sensor-alerts-overview-by-metric
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AuthToken,
        [Parameter(Mandatory = $true)]
        [string]$NetworkId,
        [Parameter(Mandatory = $false)]
        [string]$t0 = $null,
        [Parameter(Mandatory = $false)]
        [string]$t1 = $null,
        [Parameter(Mandatory = $false)]
        [int]$timespan = $null,
        [Parameter(Mandatory = $false)]
        [int]$interval = $null
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
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
        if ($interval) {
            $queryParams['interval'] = $interval
        }
        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/alerts/overview/byMetric?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}