function Get-MerakiNetworkSwitchDHCPV4ServersSeen {
    <#
    .SYNOPSIS
        Gets the DHCPv4 servers seen for a Meraki network switch.
    .DESCRIPTION
        This function retrieves the DHCPv4 servers seen for a Meraki network switch using the Meraki Dashboard API.
    .PARAMETER AuthToken
        The API authentication token for the Meraki Dashboard.
    .PARAMETER networkId
        The ID of the Meraki network to retrieve the DHCPv4 servers seen for.
    .PARAMETER t0
        The beginning of the timespan for which DHCPv4 servers will be fetched. Format is ISO-8601 (YYYY-MM-DDTHH:MM:SS). This parameter is required if the timespan parameter is not used.
    .PARAMETER timespan
        The timespan for which DHCPv4 servers will be fetched. This parameter is required if the t0 parameter is not used. The maximum value of this parameter is 365 days.
    .PARAMETER perPage
        The number of entries per page to return. Default is 10.
    .PARAMETER startingAfter
        A token used to retrieve the next page of results. This is obtained from the 'nextPage' property in the response of the previous call. Default is null.
    .PARAMETER endingBefore
        A token used to retrieve the previous page of results. This is obtained from the 'previousPage' property in the response of the previous call. Default is null.
    .EXAMPLE
        PS C:\> Get-MerakiNetworkSwitchDHCPV4ServersSeen -AuthToken "api_token" -networkId "L_123456789"
        Returns the DHCPv4 servers seen for the specified Meraki network switch.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore
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
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/switch/dhcp/v4/servers/seen?$queryString"
        $URI = [uri]::EscapeUriString($URL)
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
