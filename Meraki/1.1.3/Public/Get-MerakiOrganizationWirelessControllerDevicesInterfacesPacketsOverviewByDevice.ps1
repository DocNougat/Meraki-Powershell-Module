function Get-MerakiOrganizationWirelessControllerDevicesInterfacesPacketsOverviewByDevice {
    <#
    .SYNOPSIS
    Retrieves an overview of interface packet statistics by device for wireless controller devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerDevicesInterfacesPacketsOverviewByDevice queries the Meraki Dashboard API
    endpoint to return packet overview statistics for wireless controller device interfaces grouped by device.
    It constructs the request using the provided API key, optional time filters, pagination parameters, and optional
    filters for device serial numbers or interface names.

    This function relies on helper functions New-MerakiQueryString (to build the query string) and optionally Get-OrgID
    (if OrganizationID is not supplied, it will be obtained via Get-OrgID -AuthToken $AuthToken).

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not supplied, the function attempts to determine the organization ID
    using Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the function will return an error
    message asking for an explicit OrganizationID.

    .PARAMETER t0
    The beginning of the time range for the data. Use an ISO 8601 timestamp (e.g., "2021-01-01T00:00:00Z").

    .PARAMETER t1
    The end of the time range for the data. Use an ISO 8601 timestamp.

    .PARAMETER timespan
    An alternative to t0/t1: the timespan in seconds from now for which data will be returned. If provided, this is
    used instead of explicit t0/t1 timestamps.

    .PARAMETER perPage
    Integer specifying the number of entries per page to return (pagination).

    .PARAMETER startingAfter
    Pagination token: return results starting after this token.

    .PARAMETER endingBefore
    Pagination token: return results ending before this token.

    .PARAMETER serials
    An array of device serial numbers to filter the results. These are sent as query parameters named "serials[]".
    Example: -serials @("Q2XX-XXXX-XXXX","Q2YY-YYYY-YYYY")

    .PARAMETER names
    An array of interface names to filter the results. These are sent as query parameters named "names[]".
    Example: -names @("eth0","wlan0")

    .EXAMPLE
    PS> Get-MerakiOrganizationWirelessControllerDevicesInterfacesPacketsOverviewByDevice -AuthToken $env:MERAKI_API_KEY -OrganizationID "123456" -timespan 3600

    Retrieves the last hour of interface packet overview statistics for organization 123456.

    .NOTES
    - Query parameter arrays are sent using the "paramName[]" convention (serials[] and names[]).
    - Timestamps should be provided in ISO 8601 format and will be forwarded to the Meraki API as-is.

    .LINK
    https://developer.cisco.com/meraki/api-v1/get-organization-wireless-controller-devices-interfaces-packets-overview-by-device
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/interfaces/packets/overview/byDevice?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}