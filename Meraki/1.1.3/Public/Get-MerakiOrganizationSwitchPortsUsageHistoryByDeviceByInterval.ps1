function Get-MerakiOrganizationSwitchPortsUsageHistoryByDeviceByInterval {
    <#
    .SYNOPSIS
    Retrieves switch ports usage history by device (by interval) for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationSwitchPortsUsageHistoryByDeviceByInterval queries the Meraki Dashboard API
    (/organizations/{organizationId}/switch/ports/topology/discovery/byDevice) and returns usage history
    data for switch ports grouped by device and interval. The function accepts time range filters,
    various device/port filters and supports pagination parameters. Query parameters that accept multiple
    values (arrays) are sent using repeated query keys (e.g. macs[], networkIds[]).

    .PARAMETER AuthToken
    Required. The Meraki API key to use for authentication. Provided as the X-Cisco-Meraki-API-Key header.

    .PARAMETER OrganizationID
    Optional. The organization ID to query. If not provided, the function attempts to resolve an organization
    ID by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, you must specify an ID.

    .PARAMETER t0
    Optional. ISO 8601 / RFC3339 formatted start timestamp for the query (e.g. 2020-01-01T00:00:00Z).
    When specified with t1, the API returns data between t0 and t1.

    .PARAMETER t1
    Optional. ISO 8601 / RFC3339 formatted end timestamp for the query (e.g. 2020-01-02T00:00:00Z).

    .PARAMETER timespan
    Optional. Length of the time window in seconds (integer). Use instead of t0/t1 for a relative time window.

    .PARAMETER interval
    Optional. Interval size for aggregation. Provide an integer value (as accepted by the Meraki API) to
    control the granularity of returned data.

    .PARAMETER perPage
    Optional. Page size for paginated responses (number of results per page).

    .PARAMETER startingAfter
    Optional. Pagination cursor. Return results starting after this cursor value.

    .PARAMETER endingBefore
    Optional. Pagination cursor. Return results ending before this cursor value.

    .PARAMETER configurationUpdatedAfter
    Optional. ISO 8601 / RFC3339 timestamp. Filters results to only include ports whose configuration was
    updated after this timestamp.

    .PARAMETER mac
    Optional. Single MAC address to filter results.

    .PARAMETER macs
    Optional. Array of MAC addresses to filter results. Sent as macs[] query parameters.

    .PARAMETER name
    Optional. Port name filter.

    .PARAMETER networkIds
    Optional. Array of network IDs to filter results. Sent as networkIds[] query parameters.

    .PARAMETER portProfileIds
    Optional. Array of port profile IDs to filter results. Sent as portProfileIds[] query parameters.

    .PARAMETER serial
    Optional. Single device serial number to filter results.

    .PARAMETER serials
    Optional. Array of device serial numbers to filter results. Sent as serials[] query parameters.

    .EXAMPLE
    # Basic usage with organization and timespan
    Get-MerakiOrganizationSwitchPortsUsageHistoryByDeviceByInterval -AuthToken $env:MERAKI_API_KEY -OrganizationID "123456" -timespan 86400 -interval 3600

    .NOTES
    - Requires network connectivity and a valid Meraki API key with appropriate permissions for the target organization.
    - Time parameters (t0, t1, configurationUpdatedAfter) should be provided in ISO 8601 / RFC3339 format (UTC).
    - timespan is expressed in seconds and is mutually exclusive with t0/t1 (use either timespan or t0/t1).
    - Array parameters are passed as repeated query string keys (e.g. macs[]=..., networkIds[]=...).
    - The function uses Invoke-RestMethod and will throw errors returned by the API or network layer.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-switch-ports-topology-discovery-by-device

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
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [string]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$interval = $null,
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
            if ($t1) {
                $queryParams['t1'] = $t1
            }
            if ($timespan) {
                $queryParams['timespan'] = $timespan
            }
            if ($interval) {
                $queryParams['interval'] = $interval
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/switch/ports/usage/history/byDevice/byInterval?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}