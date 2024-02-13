function Get-MerakiNetworkPoliciesByClient {
    <#
    .SYNOPSIS
    Retrieves client policies for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkPoliciesByClient function retrieves client policies for a specified Meraki network using the Meraki API. You must provide an API authentication token and the network ID as parameters.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkID
    The ID of the network to retrieve client policies for.

    .PARAMETER perPage
    The number of entries per page. Default is 10.

    .PARAMETER startingAfter
    A token used to retrieve the next page of results.

    .PARAMETER endingBefore
    A token used to retrieve the previous page of results.

    .PARAMETER t0
    The beginning of the timespan for the data. The format is ISO 8601 (e.g. 2016-01-01T00:00:00Z).

    .PARAMETER timespan
    The timespan for which the data should be fetched, in seconds.

    .EXAMPLE
    Get-MerakiNetworkPoliciesByClient -AuthToken '12345' -NetworkID 'L_123456789'

    This example retrieves client policies for the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkID,
        [Parameter(Mandatory=$false)]
        [int]$perPage = 10,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore,
        [Parameter(Mandatory=$false)]
        [string]$t0,
        [Parameter(Mandatory=$false)]
        [int]$timespan
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

        $URL = "https://api.meraki.com/api/v1/networks/$networkId/policies/byClient?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
