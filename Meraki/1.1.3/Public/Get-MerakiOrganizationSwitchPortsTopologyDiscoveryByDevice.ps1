function Get-MerakiOrganizationSwitchPortsTopologyDiscoveryByDevice {
    <#
    .SYNOPSIS
    Retrieves switch port topology discovery information grouped by device for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationSwitchPortsTopologyDiscoveryByDevice calls the Meraki Dashboard API endpoint
    /organizations/{organizationId}/switch/ports/topology/discovery/byDevice and returns topology discovery
    data for switch ports, optionally filtered by time range, device identifiers, names, networks, port profiles,
    and paginated using Meraki's pagination parameters.

    .PARAMETER AuthToken
    [string] (Required)
    Your Meraki API key. This is sent as the X-Cisco-Meraki-API-Key header.

    .PARAMETER OrganizationID
    [string] (Optional)
    The organization ID to query. If omitted, the function attempts to determine the org ID by calling Get-OrgID -AuthToken $AuthToken.
    If multiple organizations are found, the function requests that you specify an organization ID explicitly.

    .PARAMETER t0
    [string] (Optional)
    The beginning of the timespan for the data (ISO 8601 timestamp). When provided, results are filtered from this time onward.

    .PARAMETER timespan
    [string] (Optional)
    A duration in seconds or an ISO 8601 interval describing how far back from now to fetch data. Used to filter results by time.

    .PARAMETER perPage
    [int] (Optional)
    Number of entries per page for paginated results. Maps to the perPage query parameter.

    .PARAMETER startingAfter
    [string] (Optional)
    A pagination cursor; return items after the given ID.

    .PARAMETER endingBefore
    [string] (Optional)
    A pagination cursor; return items before the given ID.

    .PARAMETER configurationUpdatedAfter
    [string] (Optional)
    Filter results to devices whose configuration was updated after this timestamp (ISO 8601).

    .PARAMETER mac
    [string] (Optional)
    Filter results by a single MAC address.

    .PARAMETER macs
    [array] (Optional)
    Filter results by multiple MAC addresses. Passed as macs[] in the query string.

    .PARAMETER name
    [string] (Optional)
    Filter results by device name.

    .PARAMETER networkIds
    [array] (Optional)
    Filter results by one or more network IDs. Passed as networkIds[] in the query string.

    .PARAMETER portProfileIds
    [array] (Optional)
    Filter results by one or more port profile IDs. Passed as portProfileIds[] in the query string.

    .PARAMETER serial
    [string] (Optional)
    Filter results by a single device serial number.

    .PARAMETER serials
    [array] (Optional)
    Filter results by multiple device serial numbers. Passed as serials[] in the query string.

    .EXAMPLE
    # Basic usage with API key and explicit organization
    Get-MerakiOrganizationSwitchPortsTopologyDiscoveryByDevice -AuthToken $env:MERAKI_API_KEY -OrganizationID "123456"

    .EXAMPLE
    # Filter by time range and a single MAC
    Get-MerakiOrganizationSwitchPortsTopologyDiscoveryByDevice -AuthToken $token -OrganizationID $orgId -t0 "2025-01-01T00:00:00Z" -timespan 86400 -mac "aa:bb:cc:dd:ee:ff"

    .EXAMPLE
    # Request multiple MACs and network IDs with pagination
    Get-MerakiOrganizationSwitchPortsTopologyDiscoveryByDevice -AuthToken $token -OrganizationID $orgId -macs @("aa:bb:cc:dd:ee:ff","11:22:33:44:55:66") -networkIds @("N_123","N_456") -perPage 100

    .NOTES
    - This function issues an HTTP GET to the Meraki Dashboard API and will throw on HTTP or network errors.
    - Ensure your AuthToken has the necessary permissions to read organization switch topology information.
    - The function relies on New-MerakiQueryString to build the query string and Get-OrgID when OrganizationID is not provided.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [string]$configurationUpdatedAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$mac,
        [parameter(Mandatory=$false)]
        [array]$macs,
        [parameter(Mandatory=$false)]
        [string]$name,
        [parameter(Mandatory=$false)]
        [array]$networkIds,
        [parameter(Mandatory=$false)]
        [array]$portProfileIds,
        [parameter(Mandatory=$false)]
        [string]$serial,
        [parameter(Mandatory=$false)]
        [array]$serials
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
            
            if ($t0) {
                $queryParams['t0'] = $t0
            }
            if ($timespan) {
                $queryParams['timespan'] = $timespan
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
            if ($configurationUpdatedAfter) {
                $queryParams['configurationUpdatedAfter'] = $configurationUpdatedAfter
            }
            if ($mac) {
                $queryParams['mac'] = $mac
            }
            if ($macs) {
                $queryParams['macs[]'] = $macs
            }
            if ($name) {
                $queryParams['name'] = $name
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($portProfileIds) {
                $queryParams['portProfileIds[]'] = $portProfileIds
            }
            if ($serial) {
                $queryParams['serial'] = $serial
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/switch/ports/topology/discovery/byDevice?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}