function Get-MerakiNetworkClients {
    <#
    .SYNOPSIS
    Retrieves a list of clients in a Meraki network that match the specified filters.

    .DESCRIPTION
    The Get-MerakiNetworkClients function retrieves a list of clients in a Meraki network that match the specified filters.
    If no filters are specified, all clients in the network are returned.
    This function requires an API key that has access to the specified Meraki network.

    .PARAMETER AuthToken
    The Meraki API key.

    .PARAMETER NetworkId
    The ID of the Meraki network to retrieve clients from.

    .PARAMETER t0
    An optional parameter that specifies the beginning of the time range for the query.
    This parameter is ignored if the timespan parameter is specified.

    .PARAMETER timespan
    An optional parameter that specifies the duration of the time range for the query, in seconds.
    If this parameter is not specified, the entire time range from the beginning of the network to the present is used.

    .PARAMETER perPage
    An optional parameter that specifies the number of clients to return per page.
    If not specified, the default of 10 is used.

    .PARAMETER startingAfter
    An optional parameter that specifies the starting client ID to return in the list.
    This parameter is used to page through the list of clients.

    .PARAMETER endingBefore
    An optional parameter that specifies the ending client ID to return in the list.
    This parameter is used to page through the list of clients.

    .PARAMETER statuses
    An optional array of client statuses to filter by.
    Possible values are "Online", "Offline", "Recent", and "Deprecated".

    .PARAMETER ip
    An optional parameter that filters clients by IP address.

    .PARAMETER ip6
    An optional parameter that filters clients by IPv6 address.

    .PARAMETER ip6Local
    An optional parameter that filters clients by link-local IPv6 address.

    .PARAMETER mac
    An optional parameter that filters clients by MAC address.

    .PARAMETER os
    An optional parameter that filters clients by operating system.

    .PARAMETER description
    An optional parameter that filters clients by description.

    .PARAMETER vlan
    An optional parameter that filters clients by VLAN.

    .PARAMETER recentDeviceConnections
    An optional array of recent device connections to filter by.

    .EXAMPLE
    Get-MerakiNetworkClients -AuthToken $AuthToken -NetworkId $NetworkId

    This example retrieves all clients in the specified Meraki network.

    .EXAMPLE
    Get-MerakiNetworkClients -AuthToken $AuthToken -NetworkId $NetworkId -statuses "Online", "Recent"

    This example retrieves all clients in the specified Meraki network that are currently online or were recently online.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [array]$statuses = $null,
        [parameter(Mandatory=$false)]
        [string]$ip = $null,
        [parameter(Mandatory=$false)]
        [string]$ip6 = $null,
        [parameter(Mandatory=$false)]
        [string]$ip6Local = $null,
        [parameter(Mandatory=$false)]
        [string]$mac = $null,
        [parameter(Mandatory=$false)]
        [string]$os = $null,
        [parameter(Mandatory=$false)]
        [string]$description = $null,
        [parameter(Mandatory=$false)]
        [string]$vlan = $null,
        [parameter(Mandatory=$false)]
        [array]$recentDeviceConnections = $null
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
        if ($statuses) {
                $queryParams['statuses[]'] = $statuses
        }
        if ($ip) {
                $queryParams['ip'] = $ip
        }
        if ($ip6) {
                $queryParams['ip6'] = $ip6
        }
        if ($ip6Local) {
                $queryParams['ip6Local'] = $ip6Local
        }
        if ($mac) {
                $queryParams['mac'] = $mac
        }
        if ($os) {
                $queryParams['os'] = $os
        }
        if ($description) {
                $queryParams['description'] = $description
        }
        if ($vlan) {
                $queryParams['vlan'] = $vlan
        }
        if ($recentDeviceConnections) {
                $queryParams['recentDeviceConnections[]'] = $recentDeviceConnections
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$networkId/clients?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}