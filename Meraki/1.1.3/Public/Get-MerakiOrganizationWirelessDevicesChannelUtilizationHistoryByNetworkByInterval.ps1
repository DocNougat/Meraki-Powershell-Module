function Get-MerakiOrganizationWirelessDevicesChannelUtilizationHistoryByNetworkByInterval {
    <#
    .SYNOPSIS
    Retrieves wireless devices' channel utilization history aggregated by network and interval for a Meraki organization.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint:
    GET /organizations/{organizationId}/wireless/devices/channelUtilization/history/byNetwork/byInterval
    Builds query parameters from the supplied arguments (t0, t1, timespan, perPage, startingAfter, endingBefore, networkIds[], serials[], interval),
    adds the X-Cisco-Meraki-API-Key header, and returns the deserialized JSON response. OrganizationID defaults to the result of Get-OrgID -AuthToken $AuthToken.

    .PARAMETER AuthToken
    Meraki API key. Sent in the X-Cisco-Meraki-API-Key request header. (Mandatory)

    .PARAMETER OrganizationID
    Target organization ID. If not provided, this function calls Get-OrgID -AuthToken $AuthToken to determine the ID. If multiple organizations are found, the function returns the message "Multiple organizations found. Please specify an organization ID."

    .PARAMETER t0
    ISO 8601 timestamp for the beginning of the timespan (e.g., "2023-01-01T00:00:00Z").

    .PARAMETER t1
    ISO 8601 timestamp for the end of the timespan.

    .PARAMETER timespan
    Timespan in seconds from which to retrieve data (mutually exclusive with t0/t1).

    .PARAMETER perPage
    Integer specifying number of results per page for paginated responses.

    .PARAMETER startingAfter
    Pagination cursor to continue results after a specific item.

    .PARAMETER endingBefore
    Pagination cursor to return results before a specific item.

    .PARAMETER networkIds
    Array of network IDs to filter results. Passed as networkIds[] in the query string.

    .PARAMETER serials
    Array of device serial numbers to filter results. Passed as serials[] in the query string.

    .PARAMETER interval
    Aggregation interval for returned data (e.g., interval grouping value). Included in the query string as interval.

    .EXAMPLE
    # Basic call using API token and explicit organization ID
    Get-MerakiOrganizationWirelessDevicesChannelUtilizationHistoryByNetworkByInterval -AuthToken $token -OrganizationID "123456" -timespan 3600

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
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/devices/channelUtilization/history/byNetwork/byInterval?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}