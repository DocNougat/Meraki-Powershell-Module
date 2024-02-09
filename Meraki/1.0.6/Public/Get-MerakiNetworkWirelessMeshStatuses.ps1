function Get-MerakiNetworkWirelessMeshStatuses {
    <#
    .SYNOPSIS
    Retrieves wireless mesh status information for a specified Meraki network.
    .DESCRIPTION
    This function retrieves wireless mesh status information for a specified Meraki network using the Meraki Dashboard API.
    .PARAMETER AuthToken
    The Meraki API token for the account.
    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the wireless mesh status information.
    .PARAMETER perPage
    The number of results per page to return. Default is null.
    .PARAMETER startingAfter
    A token used to specify the starting point for retrieving results. Default is null.
    .PARAMETER endingBefore
    A token used to specify the ending point for retrieving results. Default is null.
    .EXAMPLE
    PS> Get-MerakiNetworkWirelessMeshStatuses -AuthToken "1234" -networkId "abcd" -perPage 10
    Retrieves the wireless mesh status information for network "abcd" using the Meraki API token "1234", returning 10 results per page.
    #>
    [CmdletBinding()]
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

        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/meshStatuses?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}