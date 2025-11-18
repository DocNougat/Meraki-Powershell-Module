function Get-MerakiOrganizationSwitchPortsClientsOverviewByDevice {
    <#
    .SYNOPSIS
    Retrieves an overview of clients seen on switch ports, aggregated by device, for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint to return a device-level overview of clients observed on switch ports within the specified organization.
    Supports filtering by time range, device/port identifiers, MAC/serial filters and pagination parameters.

    .PARAMETER AuthToken
    [string] (Required)
    The Cisco Meraki API key used to authenticate the request. This value is supplied in the X-Cisco-Meraki-API-Key header.

    .PARAMETER OrganizationID
    [string]
    The ID of the Meraki organization to query. If not provided, the cmdlet attempts to determine the organization ID via Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, an explicit organization ID must be specified.

    .PARAMETER perPage
    [int]
    Number of entries to return per page for paginated results.

    .PARAMETER startingAfter
    [string]
    Pagination token indicating the cursor to start returning results after.

    .PARAMETER endingBefore
    [string]
    Pagination token indicating the cursor to end results before.

    .PARAMETER t0
    [string]
    Start of the timespan for the query, in ISO 8601 / RFC3339 format (e.g. 2021-01-01T00:00:00Z). If omitted, default server behavior applies.

    .PARAMETER timespan
    [string]
    Length of the timespan for the query in seconds. When supplied, it specifies the period (ending at t0 or now if t0 not supplied) over which to aggregate client data.

    .PARAMETER configurationUpdatedAfter
    [string]
    Return results for devices whose configuration was updated after this timestamp (ISO 8601 / RFC3339).

    .PARAMETER mac
    [string]
    Filter results to clients matching a single MAC address.

    .PARAMETER macs
    [array]
    Filter results to clients matching any of the provided MAC addresses. Pass an array of MAC strings.

    .PARAMETER name
    [string]
    Filter devices by (partial or full) device name.

    .PARAMETER networkIds
    [array]
    Filter results to one or more network IDs. Pass an array of network ID strings.

    .PARAMETER portProfileIds
    [array]
    Filter results to one or more port profile IDs. Pass an array of port profile ID strings.

    .PARAMETER serial
    [string]
    Filter results to a single device by serial number.

    .PARAMETER serials
    [array]
    Filter results to multiple devices by their serial numbers. Pass an array of serial strings.

    .EXAMPLE
    # Filter by multiple MAC addresses and paginate
    PS> Get-MerakiOrganizationSwitchPortsClientsOverviewByDevice -AuthToken $token -OrganizationID '1234' -macs @('aa:bb:cc:dd:ee:ff','11:22:33:44:55:66') -perPage 100

    .NOTES
    - Requires a valid Meraki Dashboard API key with appropriate permissions to read organization switch data.
    - Date/time values should be provided in ISO 8601 / RFC3339 format where applicable.
    - Array parameters (macs, networkIds, portProfileIds, serials) should be supplied as PowerShell arrays.
    - The cmdlet performs URL-encoding of the final request URI and adds a custom UserAgent header.
    - Consult Meraki Dashboard API documentation for details on expected response fields and additional filtering semantics.

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API documentation)
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$timespan = $null,
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
            
            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
            if ($t0) {
                $queryParams['t0'] = $t0
            }
            if ($timespan) {
                $queryParams['timespan'] = $timespan
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
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/switch/ports/clients/overview/byDevice?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}