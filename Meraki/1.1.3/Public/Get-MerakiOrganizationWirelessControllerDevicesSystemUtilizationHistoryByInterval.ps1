function Get-MerakiOrganizationWirelessControllerDevicesSystemUtilizationHistoryByInterval {
    <#
    .SYNOPSIS
    Retrieves historical wireless controller system utilization metrics for devices in a Meraki organization, returned at the configured reporting interval.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerDevicesSystemUtilizationHistoryByInterval calls the Meraki REST API endpoint to obtain system utilization history (CPU, memory, etc.) for wireless controller devices in the specified organization. Results are returned as deserialized JSON (PowerShell objects). Supports filtering by time range, timespan, device serials, and pagination.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This is mandatory and must have sufficient privileges to read organization wireless controller telemetry.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not provided, the function attempts to determine it using Get-OrgID -AuthToken <AuthToken>. If multiple organizations are available, a specific OrganizationID must be supplied.

    .PARAMETER t0
    The start of the timespan for the query. Should be an ISO 8601 timestamp (for example: 2025-01-01T00:00:00Z). Mutually usable with t1; if omitted, the API will use timespan or default behavior.

    .PARAMETER t1
    The end of the timespan for the query. Should be an ISO 8601 timestamp (for example: 2025-01-02T00:00:00Z). Use together with t0 to define an explicit range.

    .PARAMETER timespan
    A relative timespan in seconds (integer or string convertible to numeric). When provided, the API returns data from (now - timespan) to now unless t0/t1 are specified.

    .PARAMETER perPage
    The number of items to return per page (for paginated responses). Integer value as accepted by the Meraki API.

    .PARAMETER startingAfter
    Pagination cursor. Return entries after the given cursor value. Use with perPage to paginate forward.

    .PARAMETER endingBefore
    Pagination cursor. Return entries before the given cursor value. Use with perPage to paginate backward.

    .PARAMETER serials
    Array of device serial numbers to filter results to specific devices. Provided as an array (e.g. @('Q2XX-AAAA-BBBB','Q2YY-CCCC-DDDD')). If supplied, the query parameter is sent as serials[] for each element.

    .EXAMPLE
    # Retrieve the last 24 hours of utilization for an organization (using timespan in seconds)
    Get-MerakiOrganizationWirelessControllerDevicesSystemUtilizationHistoryByInterval -AuthToken '0123456789abcdef' -OrganizationID '123456' -timespan 86400

    .NOTES
    - Requires an active Meraki account and an API key with permission to read organization wireless controller data.
    - Timestamps should be provided in ISO 8601 format (UTC recommended).
    - The function will throw exceptions if the underlying HTTP call fails; wrap calls in try/catch where needed.
    - If OrganizationID is not provided and multiple organizations are associated with the provided API key, the function will request you specify an OrganizationID.
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/system/utilization/history/byInterval?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}