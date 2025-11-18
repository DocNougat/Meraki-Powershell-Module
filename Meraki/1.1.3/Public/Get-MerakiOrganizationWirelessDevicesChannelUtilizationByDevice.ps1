function Get-MerakiOrganizationWirelessDevicesChannelUtilizationByDevice {
    <#
    .SYNOPSIS
    Retrieves wireless channel utilization by device for a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessDevicesChannelUtilizationByDevice calls the Meraki Dashboard API to return channel utilization metrics grouped by device for an organization. Results can be filtered by time range, specific networks, or device serials and support pagination. The function expects a valid Meraki API key and will construct query parameters from the provided arguments.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. Passed in the "X-Cisco-Meraki-API-Key" header. This parameter is required.

    .PARAMETER OrganizationID
    The ID of the Meraki organization to query. If omitted, the function attempts to determine the organization ID by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function returns a message prompting specification of an OrganizationID.

    .PARAMETER t0
    ISO 8601 timestamp string specifying the beginning of the timespan for the data (for example: 2020-01-01T00:00:00Z). Optional; when provided the query will include this as the start time.

    .PARAMETER t1
    ISO 8601 timestamp string specifying the end of the timespan for the data. Optional; when provided the query will include this as the end time.

    .PARAMETER timespan
    Timespan in seconds for the query (alternative to t0/t1). When provided, the API will return data for the specified number of seconds back from t1 (or from now if t1 not specified).

    .PARAMETER perPage
    Integer specifying the number of results per page for paginated responses. Optional.

    .PARAMETER startingAfter
    Pagination token used to fetch the next page of results. Optional.

    .PARAMETER endingBefore
    Pagination token used to fetch the previous page of results. Optional.

    .PARAMETER networkIds
    Array of network IDs to filter results to specific networks. Each element will be passed as networkIds[] in the query string.

    .PARAMETER serials
    Array of device serial numbers to filter results to specific devices. Each element will be passed as serials[] in the query string.

    .PARAMETER interval
    Aggregation interval (in seconds) for the returned metrics. Optional; if omitted defaults to the API's standard aggregation interval.

    .EXAMPLE
    # Basic usage with organization ID
    Get-MerakiOrganizationWirelessDevicesChannelUtilizationByDevice -AuthToken 'myApiKey' -OrganizationID '123456'

    .NOTES
    - This function calls the Meraki Dashboard API endpoint:
    /organizations/{organizationId}/wireless/devices/channelUtilization/byDevice
    - Authentication is performed via the "X-Cisco-Meraki-API-Key" header.
    - On API or network errors the function will throw the underlying exception.
    - Be mindful of API rate limits; implement retry/backoff as needed in calling code.

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
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/devices/channelUtilization/byDevice?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}