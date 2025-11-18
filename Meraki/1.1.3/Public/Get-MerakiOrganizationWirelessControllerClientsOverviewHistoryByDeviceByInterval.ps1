function Get-MerakiOrganizationWirelessControllerClientsOverviewHistoryByDeviceByInterval {
    <#
    .SYNOPSIS
    Retrieves wireless controller clients overview history by device broken down by interval for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint:
        /organizations/{organizationId}/wirelessController/clients/overview/history/byDevice/byInterval

    Returns deserialized JSON containing historical client overview metrics grouped by device and interval. Supports time range and filtering parameters, as well as cursor-based pagination. The function uses an API key passed in the X-Cisco-Meraki-API-Key header.

    .PARAMETER AuthToken
    [string] (Mandatory)
    The Meraki API key used to authenticate the request. Provide a valid API key with appropriate access to the target organization.

    .PARAMETER OrganizationID
    [string] (Optional)
    The organization ID to query. If not supplied, the function attempts to resolve the organization ID by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function returns the message: "Multiple organizations found. Please specify an organization ID."

    .PARAMETER t0
    [string] (Optional)
    Start of the timespan. Accepts an ISO 8601 timestamp (e.g. 2020-01-01T00:00:00Z) or a Unix epoch time string. If omitted, the API will use its default behavior.

    .PARAMETER t1
    [string] (Optional)
    End of the timespan. Accepts an ISO 8601 timestamp or Unix epoch time string. Used together with t0 or timespan to bound the query.

    .PARAMETER timespan
    [string] (Optional)
    Length of the timespan in seconds to query from t0 (or from now if t0 omitted). Mutually exclusive with t1 when using relative times; follow API semantics.

    .PARAMETER perPage
    [int] (Optional)
    Number of items to return per page for paginated responses. Use with startingAfter / endingBefore to page through results.

    .PARAMETER startingAfter
    [string] (Optional)
    Pagination cursor; return results starting after this cursor. Used for forward paging.

    .PARAMETER endingBefore
    [string] (Optional)
    Pagination cursor; return results ending before this cursor. Used for backward paging.

    .PARAMETER networkIds
    [array] (Optional)
    Array of network ID strings to filter results to one or more networks. Sent as repeated query parameter networkIds[].

    .PARAMETER serials
    [array] (Optional)
    Array of device serial numbers to filter results to specific devices. Sent as repeated query parameter serials[].

    .PARAMETER resolution
    [int] (Optional)
    Interval resolution for the returned time-series data (typically specified in seconds). If omitted default resolution from the API is used.

    .EXAMPLE
    PS> Get-MerakiOrganizationWirelessControllerClientsOverviewHistoryByDeviceByInterval -AuthToken $apiKey -networkIds @("N_1","N_2") -serials @("Q2XX-XXXX-XXXX")

    Filters the returned history to the supplied networks and device serials.

    .NOTES
    - Requires network connectivity to api.meraki.com and a valid API key.
    - Pagination cursors (startingAfter, endingBefore) are provided by the API response when results are paginated.

    .LINK
    https://developer.cisco.com/meraki/api-v1/
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
        [int]$resolution = $null
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
            If ($resolution) { 
                $queryParams["resolution"] = $resolution 
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/clients/overview/history/byDevice/byInterval?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}