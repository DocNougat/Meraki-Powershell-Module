function Get-MerakiOrganizationWirelessDevicesChannelUtilizationHistoryByDeviceByInterval {
    <#
    .SYNOPSIS
    Retrieves wireless channel utilization history by device, aggregated by interval, for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint:
    GET /organizations/{organizationId}/wireless/devices/channelUtilization/history/byDevice/byInterval
    and returns channel utilization metrics for wireless devices in the specified organization. Query parameters such as time range, paging, filtering by network IDs or serials, and aggregation interval are supported.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). Mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not supplied, the function attempts to determine it by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, specify an explicit OrganizationID.

    .PARAMETER t0
    Start time for the data. Use an ISO 8601 timestamp (e.g. 2020-01-01T00:00:00Z). If omitted, the API default behavior applies.

    .PARAMETER t1
    End time for the data. Use an ISO 8601 timestamp (e.g. 2020-01-02T00:00:00Z). If omitted, the API default behavior applies.

    .PARAMETER timespan
    A timespan in seconds (integer) to retrieve data for. If provided, t0 and t1 are not required. The API will return data for the given timespan ending at t1 (if provided) or the current time.

    .PARAMETER perPage
    Number of entries per page for paginated responses. If omitted, the API default is used.

    .PARAMETER startingAfter
    Pagination cursor to return results after the specified object ID. Used for retrieving subsequent pages.

    .PARAMETER endingBefore
    Pagination cursor to return results before the specified object ID. Used for retrieving previous pages.

    .PARAMETER networkIds
    Array of network IDs to filter results to specific networks. Sent as repeated query parameters networkIds[].

    .PARAMETER serials
    Array of device serial numbers to filter results to specific devices. Sent as repeated query parameters serials[].

    .PARAMETER interval
    Aggregation interval in minutes for the returned metrics (integer). If omitted, the API default interval is used.

    .EXAMPLE
    # Basic usage with API key and explicit organization
    Get-MerakiOrganizationWirelessDevicesChannelUtilizationHistoryByDeviceByInterval -AuthToken 'APIKEY' -OrganizationID '123456'

    .EXAMPLE
    # Query a specific time window and interval
    Get-MerakiOrganizationWirelessDevicesChannelUtilizationHistoryByDeviceByInterval -AuthToken 'APIKEY' -OrganizationID '123456' -t0 '2025-01-01T00:00:00Z' -t1 '2025-01-02T00:00:00Z' -interval 600

    .NOTES
    - Requires a valid Meraki API key with permissions to read organization wireless telemetry.
    - Time parameters should be provided in UTC or ISO 8601 format to avoid ambiguity.
    - networkIds and serials are passed as repeated query parameters (networkIds[] / serials[]).
    - The function expects helper functions/utilities used by the module (for example New-MerakiQueryString and Get-OrgID) to be available in the session.

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
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [array]$networkIds,
        [parameter(Mandatory=$false)]
        [array]$serials,
        [parameter(Mandatory=$false)]
        [int]$interval = $null
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
            If ($networkIds) { 
                $queryParams["networkIds[]"] = $networkIds
            }
            If ($serials) { 
                $queryParams["serials[]"] = $serials
            }
            If ($interval) { 
                $queryParams["interval"] = $interval 
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/devices/channelUtilization/history/byDevice/byInterval?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}