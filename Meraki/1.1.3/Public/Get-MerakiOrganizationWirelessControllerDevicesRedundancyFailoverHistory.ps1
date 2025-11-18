function Get-MerakiOrganizationWirelessControllerDevicesRedundancyFailoverHistory {
    <#
    .SYNOPSIS
    Retrieves redundancy failover history for wireless controller devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerDevicesRedundancyFailoverHistory queries the Meraki Dashboard API to return device redundancy/failover events for wireless controller devices within a specified organization. The function supports time-range filtering, pagination, and filtering by device serial numbers. If OrganizationID is not supplied, the function will attempt to resolve a single organization via Get-OrgID -AuthToken.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The unique identifier of the Meraki organization to query. If omitted, the function will call Get-OrgID -AuthToken to determine the organization. If multiple organizations are associated with the API key, you must provide this value explicitly.

    .PARAMETER t0
    Start timestamp for the query window. Use an ISO 8601 formatted date/time string (for example, "2024-01-01T00:00:00Z"). When provided, results are limited to events at or after this time.

    .PARAMETER t1
    End timestamp for the query window. Use an ISO 8601 formatted date/time string (for example, "2024-01-02T00:00:00Z"). When provided, results are limited to events at or before this time.

    .PARAMETER timespan
    An alternative to specifying both t0 and t1. Represents the timespan (in seconds) from now to include in the query. When timespan is provided, t0 and t1 are not required.

    .PARAMETER perPage
    Number of records to return per page (pagination). Provide an integer value to control page size.

    .PARAMETER startingAfter
    Pagination cursor to return records after the provided cursor/id. Use when traversing paginated results forward.

    .PARAMETER endingBefore
    Pagination cursor to return records before the provided cursor/id. Use when traversing paginated results backward.

    .PARAMETER serials
    An array of device serial numbers to filter the returned events. Provide one or more serial strings (e.g. @('Q2XX-XXXX-XXXX','Q2YY-YYYY-YYYY')).

    .EXAMPLE
    # Basic usage with explicit organization
    Get-MerakiOrganizationWirelessControllerDevicesRedundancyFailoverHistory -AuthToken 'abcd1234' -OrganizationID '123456'

    .NOTES
    - t0 and t1 should be ISO 8601 timestamps in UTC (e.g. "2024-01-01T00:00:00Z").
    - timespan is specified in seconds and is an alternative to supplying t0/t1.
    - Pagination is supported via perPage, startingAfter, and endingBefore parameters; consult API responses for pagination cursors.
    - The provided AuthToken must have sufficient privileges to read organization data.
    - The function throws terminating errors on failed HTTP requests; use try/catch or -ErrorAction to handle errors.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$t0,
        [parameter(Mandatory=$false)]
        [string]$t1,
        [parameter(Mandatory=$false)]
        [string]$timespan,
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
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
            If ($t0) { 
                $queryParams["t0"] = $t0 
            }
            If ($t1) { 
                $queryParams["t1"] = $t1 
            }
            If ($timespan) { 
                $queryParams["timespan"] = $timespan 
            }
            If ($perPage) { 
                $queryParams["perPage"] = $perPage 
            }
            If ($startingAfter) { 
                $queryParams["startingAfter"] = $startingAfter 
            }
            If ($endingBefore) { 
                $queryParams["endingBefore"] = $endingBefore 
            }
            If ($serials) { 
                $queryParams["serials[]"] = $serials
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/redundancy/failover/history?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}