function Get-MerakiNetworkApplianceClientSecurityEvents {
    <#
    .SYNOPSIS
    Gets security events for a specific client on a Meraki network appliance.
    
    .DESCRIPTION
    This function retrieves security events for a specific client on a Meraki network appliance.
    
    .PARAMETER AuthToken
    The API token used to authenticate with the Meraki dashboard.
    
    .PARAMETER NetworkId
    The ID of the network containing the Meraki appliance.
    
    .PARAMETER ClientId
    The ID of the client for which to retrieve security events.
    
    .PARAMETER t0
    The beginning of the time range for which to retrieve security events.
    
    .PARAMETER t1
    The end of the time range for which to retrieve security events.
    
    .PARAMETER timespan
    The timespan for which to retrieve security events, in seconds. If this parameter is specified, t0 and t1 are ignored.
    
    .PARAMETER perPage
    The number of events to return per page.
    
    .PARAMETER startingAfter
    The ID of the last event on the previous page. Used to paginate through results.
    
    .PARAMETER endingBefore
    The ID of the first event on the next page. Used to paginate through results.
    
    .PARAMETER sortOrder
    The order in which to return results. Valid values are "ascending" and "descending".
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceClientSecurityEvents -AuthToken $AuthToken -NetworkId $NetworkId -ClientId $ClientId -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-02T00:00:00Z"
    
    Retrieves security events for the specified client on the specified Meraki network appliance between the specified times.
    
    .NOTES
    For more information, see the Meraki API documentation: https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-client-security-events
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$ClientId,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$sortOrder = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "Content-Type" = "application/json"
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
        if ($perPage) {
            $queryParams['perPage'] = $perPage
        }
        if ($startingAfter) {
            $queryParams['startingAfter'] = $startingAfter
        }
        if ($endingBefore) {
            $queryParams['endingBefore'] = $endingBefore
        }
        if ($sortOrder) {
            $queryParams['sortOrder'] = $sortOrder
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/clients/$ClientId/security/events"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}
