function Get-MerakiOrganizationWirelessControllerDevicesInterfacesUsageHistoryByInterval {
    <#
    .SYNOPSIS
    Retrieves wireless controller interface usage history for devices in a Meraki organization aggregated by interval.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerDevicesInterfacesUsageHistoryByInterval queries the Meraki Dashboard API to return historical usage data for wireless controller device interfaces within a specified organization. The results are returned as provided by the Meraki API (JSON converted to PowerShell objects). Supports filtering by time range or timespan, paging, and filtering by device serial numbers or interface names.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is required.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to resolve the organization ID by calling Get-OrgID -AuthToken <AuthToken>. If multiple organizations are found, the function will request an explicit OrganizationID.

    .PARAMETER t0
    The beginning of the timespan for the data. Accepts an ISO 8601 timestamp (e.g., "2023-01-01T00:00:00Z"). When provided, t1 may also be supplied to define a start/end range.

    .PARAMETER t1
    The end of the timespan for the data. Accepts an ISO 8601 timestamp (e.g., "2023-01-02T00:00:00Z"). If not provided, timespan or default server behavior applies.

    .PARAMETER timespan
    Length of the timespan in seconds from t0 (or from now if t0/t1 are not provided). Use an integer value in seconds (e.g., 86400 for 24 hours). Note: timespan and explicit t0/t1 ranges should be used according to the API limits.

    .PARAMETER perPage
    Maximum number of items to return per page (pagination). Provide an integer.

    .PARAMETER startingAfter
    Pagination cursor: return entries after this cursor (used for forward pagination).

    .PARAMETER endingBefore
    Pagination cursor: return entries before this cursor (used for backward pagination).

    .PARAMETER serials
    Array of device serial numbers to filter results (e.g., @('Q2XX-XXXX-XXXX','Q2YY-YYYY-YYYY')). Sent as serials[] query parameters.

    .PARAMETER names
    Array of interface names to filter results (e.g., @('eth0','wan1')). Sent as names[] query parameters.

    .EXAMPLE
    # Retrieve last 24 hours of data for specific device serials and paginate
    Get-MerakiOrganizationWirelessControllerDevicesInterfacesUsageHistoryByInterval -AuthToken $env:MERAKI_API_KEY -OrganizationID "123456" -timespan 86400 -serials @('Q2XX-XXXX-XXXX','Q2YY-YYYY-YYYY') -perPage 100

    .NOTES
    - This function requires network connectivity to api.meraki.com and a valid API key.
    - Pagination is supported via perPage, startingAfter, and endingBefore. When results are paged, use the returned pagination cursors to iterate.
    - t0 and t1 should be provided in ISO 8601 format where applicable. timespan is expressed in seconds.
    - If multiple organizations are associated with the provided AuthToken and OrganizationID cannot be resolved automatically, supply the explicit OrganizationID.

    .LINK
    Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/

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
        [array]$serials,
        [parameter(Mandatory=$false)]
        [array]$names
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
            If ($names) { 
                $queryParams["names[]"] = $names
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/interfaces/usage/history/byInterval?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}