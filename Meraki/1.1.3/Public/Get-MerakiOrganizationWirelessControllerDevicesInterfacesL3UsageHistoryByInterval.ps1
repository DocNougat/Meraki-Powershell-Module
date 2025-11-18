function Get-MerakiOrganizationWirelessControllerDevicesInterfacesL3UsageHistoryByInterval {
    <#
    .SYNOPSIS
    Retrieves L3 interface usage history grouped by interval for wireless controller devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerDevicesInterfacesL3UsageHistoryByInterval calls the Meraki Dashboard API to return Layer 3 interface usage history (by interval) for wireless controller devices in the specified organization. If OrganizationID is not provided, it attempts to resolve a single organization using Get-OrgID -AuthToken <AuthToken>. The function builds query parameters for time range, pagination, and device serial filtering, issues an authenticated GET request, and returns the parsed JSON response.

    .PARAMETER AuthToken
    The Meraki API key used for authentication. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function calls Get-OrgID -AuthToken <AuthToken> to resolve the organization. If multiple organizations are found, the function will return an error string asking you to specify an organization ID.

    .PARAMETER t0
    Start of the time range for the data (ISO 8601 timestamp or format accepted by the Meraki API). Optional.

    .PARAMETER t1
    End of the time range for the data (ISO 8601 timestamp or format accepted by the Meraki API). Optional.

    .PARAMETER timespan
    A timespan (in seconds or the format accepted by the Meraki API) to define how far back from t1 (or now if t1 omitted) to return data. Optional.

    .PARAMETER perPage
    The number of entries per page to request from the API (pagination). Optional.

    .PARAMETER startingAfter
    A pagination cursor for results, used to retrieve the next page. Optional.

    .PARAMETER endingBefore
    A pagination cursor for results, used to retrieve the previous page. Optional.

    .PARAMETER serials
    An array of device serial numbers to filter results to specific devices. When provided, this is sent as serials[] query parameters. Optional.

    .EXAMPLE
    # Get usage history for a specific organization between two timestamps
    Get-MerakiOrganizationWirelessControllerDevicesInterfacesL3UsageHistoryByInterval -AuthToken $MERAKIKEY -OrganizationID "123456" -t0 "2024-01-01T00:00:00Z" -t1 "2024-01-02T00:00:00Z"
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/interfaces/l3/usage/history/byInterval?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}