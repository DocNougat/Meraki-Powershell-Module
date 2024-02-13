function Get-MerakiNetworkApplianceSecurityEvents {
    <#
    .SYNOPSIS
    Gets a list of security events for a Meraki network's appliance.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve a list of security events for a Meraki network's appliance.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose security events are being retrieved.
    .PARAMETER t0
    The beginning of the timespan for the security events. Can be in ISO 8601 format or Unix timestamp format.
    .PARAMETER t1
    The end of the timespan for the security events. Can be in ISO 8601 format or Unix timestamp format.
    .PARAMETER timespan
    The timespan for the security events in seconds. Overrides t0 and t1 if provided.
    .PARAMETER perPage
    The number of events to return per page.
    .PARAMETER startingAfter
    A token used to retrieve the next page of results.
    .PARAMETER endingBefore
    A token used to retrieve the previous page of results.
    .PARAMETER sortOrder
    The sort order for the events. Valid values are "ascending" and "descending".
    .EXAMPLE
    Get-MerakiNetworkApplianceSecurityEvents -AuthToken '1234' -NetworkId '5678' -t0 '2022-04-01T00:00:00Z' -t1 '2022-04-30T23:59:59Z'
    Retrieves the security events for the Meraki network with ID '5678' between April 1, 2022 and April 30, 2022 using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [Parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [Parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [Parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [Parameter(Mandatory=$false)]
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/security/events?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}