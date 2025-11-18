function Get-MerakiNetworkClientTrafficHistory {
    <#
    .SYNOPSIS
        Retrieves the traffic history for a specific client on a Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER networkId
        The ID of the Meraki network.

    .PARAMETER clientId
        The ID of the client whose traffic history is to be retrieved.

    .PARAMETER perPage
        The number of entries per page. Default is null.

    .PARAMETER startingAfter
        A starting timestamp for the query. Default is null.

    .PARAMETER endingBefore
        An ending timestamp for the query. Default is null.

    .EXAMPLE
        Get-MerakiNetworkClientTrafficHistory -AuthToken "YOUR_API_KEY" -networkId "YOUR_NETWORK_ID" -clientId "YOUR_CLIENT_ID"

        Retrieves the traffic history for the specified client on the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId,
        [Parameter(Mandatory=$true)]
        [string]$clientId,
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

        $URL = "https://api.meraki.com/api/v1/networks/$networkId/clients/$clientId/trafficHistory?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}