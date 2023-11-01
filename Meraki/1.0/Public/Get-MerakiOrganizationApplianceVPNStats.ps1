function Get-MerakiOrganizationApplianceVPNStats {
    <#
    .SYNOPSIS
    Retrieves VPN statistics for a Meraki organization's appliances.

    .DESCRIPTION
    This function retrieves VPN statistics for a Meraki organization's appliances using the Meraki Dashboard API. It requires an authentication token for the API, and the ID of the organization for which the statistics should be retrieved. The function can also filter the results by specifying various optional parameters.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrgId
    The ID of the organization for which the VPN statistics should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER perPage
    The number of entries per page to include in the result set. If not specified, all entries will be returned.

    .PARAMETER startingAfter
    Returns entries after the specified startingAfter parameter, sorted ascendingly by time.

    .PARAMETER endingBefore
    Returns entries before the specified endingBefore parameter, sorted ascendingly by time.

    .PARAMETER networkIds
    An array of network IDs to include in the result set. If not specified, statistics for all networks will be included.

    .PARAMETER t0
    The beginning of the timespan for which the statistics should be retrieved, in ISO 8601 format (e.g., "2021-01-01T00:00:00Z").

    .PARAMETER t1
    The end of the timespan for which the statistics should be retrieved, in ISO 8601 format.

    .PARAMETER timespan
    The duration of the timespan for which the statistics should be retrieved, in seconds. If this parameter is specified, t0 and t1 should not be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceVPNStats -AuthToken $AuthToken -OrgId $OrganizationID -networkIds @("N_1234567890")

    Retrieves VPN statistics for the specified organization and network ID.

    .NOTES
    This function requires the Get-MerakiOrganizations and New-MerakiQueryString functions.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-appliance-vpn-stats

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null,
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
        if ($networkIds) {
            $queryParams['networkIds[]'] = $networkIds
        }    
        $queryString = New-MerakiQueryString -queryParams $queryParams    
        $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/vpn/stats?$queryString"    
        $URI = [uri]::EscapeUriString($URL)    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}