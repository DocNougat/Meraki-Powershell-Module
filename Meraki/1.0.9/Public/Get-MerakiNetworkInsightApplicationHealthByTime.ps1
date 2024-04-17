function Get-MerakiNetworkInsightApplicationHealthByTime {
    <#
    .SYNOPSIS
    Retrieve application health score over time for a specific application.

    .DESCRIPTION
    Use this API to retrieve the application health score (0-100) over time for a specific application on the network.
    For each timestamp available, the value of the score is returned, along with a "good" and "bad" threshold which
    are used to determine whether the score is good, bad or fair.

    .PARAMETER AuthToken
    Meraki Dashboard API Key.

    .PARAMETER networkId
    The network ID.

    .PARAMETER applicationId
    The application ID.

    .PARAMETER t0
    The beginning of the timespan for the data. The maximum lookback period is 365 days from today.

    .PARAMETER t1
    The end of the timespan for the data. The maximum lookback period is 365 days from today.

    .PARAMETER timespan
    The timespan for which the information will be fetched. If timespan is specified, t0 and t1 cannot be used.
    The maximum value for timespan is 365 days.

    .PARAMETER resolution
    The time resolution in seconds for returned data. The valid resolutions are: 60, 600, 3600, 14400, 86400.
    The default is 3600 seconds.

    .EXAMPLE
    Get-MerakiNetworkInsightApplicationHealthByTime -AuthToken $AuthToken -networkId N_24329156 -applicationId "k8m5l5" -timespan 86400 -resolution 3600

    Retrieve the application health score over the last 24 hours with a resolution of 1 hour.

    .NOTES
    For more information, see https://developer.cisco.com/meraki/api-v1/#!get-network-insight-application-health-by-time
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$AuthToken,
        [parameter(Mandatory = $true)]
        [string]$networkId,
        [parameter(Mandatory = $true)]
        [string]$applicationId,
        [parameter(Mandatory = $false)]
        [string]$t0 = $null,
        [parameter(Mandatory = $false)]
        [string]$t1 = $null,
        [parameter(Mandatory = $false)]
        [int]$timespan = $null,
        [parameter(Mandatory = $false)]
        [int]$resolution = 3600
    )

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
    if ($resolution) {
        $queryParams['resolution'] = $resolution
    }
    $queryString = New-MerakiQueryString -queryParams $queryParams

    try {
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/insight/applications/$applicationId/healthByTime?$queryString"
        $URI = [uri]::EscapeUriString($URL)
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
