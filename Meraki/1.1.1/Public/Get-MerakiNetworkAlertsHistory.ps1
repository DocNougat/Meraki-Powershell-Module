function Get-MerakiNetworkAlertsHistory {
    <#
    .SYNOPSIS
    Gets the alert history for a Meraki network.

    .DESCRIPTION
    This function retrieves the alert history for a specific Meraki network, including all alerts that have been generated for the network.

    .PARAMETER AuthToken
    The authorization token for the Meraki API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which to retrieve the alert history.

    .PARAMETER perPage
    The number of records to return per page. If not specified, the API default of 10 records per page is used.

    .PARAMETER startingAfter
    A token used to retrieve the next page of results. This is obtained from the previous API call.

    .PARAMETER endingBefore
    A token used to retrieve the previous page of results. This is obtained from the previous API call.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkAlertsHistory -AuthToken "1234" -NetworkId "abcd" -perPage 20

    This example retrieves the alert history for the network with ID "abcd" and returns 20 records per page.

    .NOTES
    For more information about the Meraki API and alert history, see the Meraki documentation at https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null
    )

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }

    try {
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

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$NetworkId/alerts/history?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
