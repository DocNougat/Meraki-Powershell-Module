function Get-MerakiNetworkNetworkHealthChannelUtilization {
    <#
    .SYNOPSIS
    Retrieves channel utilization data for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkNetworkHealthChannelUtilization function retrieves channel utilization data for a specified Meraki network using the Meraki API. You must provide an API authentication token and the network ID as parameters. You can also specify optional parameters to filter the data returned.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve channel utilization data for.

    .PARAMETER t0
    The beginning of the timespan for the channel utilization data. If not specified, the timespan will be calculated based on the specified timespan or t1 parameter.

    .PARAMETER t1
    The end of the timespan for the channel utilization data. If not specified, the timespan will be calculated based on the specified timespan or t0 parameter.

    .PARAMETER timespan
    The timespan for the channel utilization data, in seconds. If not specified, the timespan will be calculated based on the specified t0 and t1 parameters.

    .PARAMETER resolution
    The time resolution for the channel utilization data, in seconds.

    .PARAMETER perPage
    The number of entries per page to return.

    .PARAMETER startingAfter
    A token used to retrieve the next page of results.

    .PARAMETER endingBefore
    A token used to retrieve the previous page of results.

    .EXAMPLE
    Get-MerakiNetworkNetworkHealthChannelUtilization -AuthToken '12345' -NetworkId 'L_123456789' -t0 '2022-01-01T00:00:00Z' -t1 '2022-01-02T00:00:00Z' -resolution 3600

    This example retrieves channel utilization data for the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'. The data returned will be for the timespan from '2022-01-01T00:00:00Z' to '2022-01-02T00:00:00Z' with a time resolution of 1 hour.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId,
        [Parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [Parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [Parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [Parameter(Mandatory=$false)]
        [int]$resolution = $null,
        [Parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($resolution) {
            $queryParams['resolution'] = $resolution
        }
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
        if ($perPage) {
            $queryParams['perPage'] = $perPage
        }
        if ($startingAfter) {
            $queryParams['startingAfter'] = $startingAfter
        }
        if ($endingBefore) {
            $queryParams['endingBefore'] = $endingBefore
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
        $URI = "https://api.meraki.com/api/v1/networks/$networkId/networkHealth/channelUtilization?$queryString"
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}