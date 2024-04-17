function Get-MerakiNetworkClientsBandwidthUsageHistory {
    <#
    .SYNOPSIS
    Gets bandwidth usage history for clients in a Meraki network.

    .DESCRIPTION
    This function retrieves the bandwidth usage history for clients in a Meraki network.
    You can specify a timespan or start/end times to limit the returned data.

    .PARAMETER AuthToken
    Required. The Meraki API key for the dashboard.

    .PARAMETER networkId
    Required. The network ID to get client bandwidth usage history for.

    .PARAMETER perPage
    Optional. The number of entries per page returned. Max 1000.

    .PARAMETER startingAfter
    Optional. A token used to retrieve the next page of results.

    .PARAMETER endingBefore
    Optional. A token used to retrieve the previous page of results.

    .PARAMETER t0
    Optional. The beginning of the timespan for the data in ISO 8601 format.

    .PARAMETER t1
    Optional. The end of the timespan for the data in ISO 8601 format.

    .PARAMETER timespan
    Optional. The timespan for the data in seconds. The maximum value is 7 days.

    .EXAMPLE
    Get-MerakiNetworkClientsBandwidthUsageHistory -AuthToken '1234' -networkId 'abcd' -t0 '2023-01-01T00:00:00Z' -t1 '2023-01-02T00:00:00Z'

    This example gets the bandwidth usage history for clients in the network with ID 'abcd' between January 1st, 2023 and January 2nd, 2023.

    .NOTES
    For more information about the Meraki API and the available parameters, see the documentation at https://developer.cisco.com/meraki/api-v1/#!get-network-clients-bandwidthUsageHistory.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($perPage) {
            $queryParams['perPage'] = $perPage
        }
        if ($startingAfter) {
            $queryParams['startingAfter'] = $startingAfter
        }
        if ($endingBefore) {
            $queryParams['endingBefore'] = $endingBefore
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
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/clients/bandwidthUsageHistory?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}