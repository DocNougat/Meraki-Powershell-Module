function Get-MerakiOrganizationWirelessControllerDevicesInterfacesL2StatusesChangeHistoryByDevice {
    <#
    .SYNOPSIS
    Retrieves the layer‑2 interface status change history for wireless controller devices in a Meraki organization, grouped by device.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessControllerDevicesInterfacesL2StatusesChangeHistoryByDevice calls the Meraki Dashboard API to return change history entries for L2 interface statuses for devices in a specified organization.
    The function builds query parameters from the provided arguments and issues a GET request to the appropriate Meraki endpoint. The OrganizationID parameter will default to the value returned by Get-OrgID -AuthToken <token> if not supplied. If multiple organizations are found by that lookup, the function will request that you explicitly specify an OrganizationID.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is mandatory.

    .PARAMETER OrganizationID
    The ID of the Meraki organization to query. If omitted the function attempts to resolve an organization ID using Get-OrgID -AuthToken <AuthToken>.

    .PARAMETER t0
    Starting timestamp for the query window. Accepts an ISO 8601 timestamp or other formats accepted by the Meraki API.

    .PARAMETER t1
    Ending timestamp for the query window. Accepts an ISO 8601 timestamp or other formats accepted by the Meraki API.

    .PARAMETER timespan
    Alternative to t0/t1: length of the time window in seconds. Use either timespan or t0/t1 to limit the query period.

    .PARAMETER perPage
    Pagination: maximum number of items to return per page. Provide an integer value.

    .PARAMETER startingAfter
    Pagination cursor: return results starting after this cursor value. Used when consuming paged responses.

    .PARAMETER endingBefore
    Pagination cursor: return results ending before this cursor value. Used when consuming paged responses.

    .PARAMETER serials
    Array of device serial numbers to restrict results to one or more devices. Passed to the API as multiple serials[] query parameters.

    .PARAMETER includeInterfacesWithoutChanges
    When $true, include interfaces that have no recorded L2 status changes during the requested period.

    .EXAMPLE
    # Minimal: specify API key and organization
    Get-MerakiOrganizationWirelessControllerDevicesInterfacesL2StatusesChangeHistoryByDevice -AuthToken 'abc123' -OrganizationID '123456'

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
        [bool]$includeInterfacesWithoutChanges
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
            If ($includeInterfacesWithoutChanges) {
                $queryParams["includeInterfacesWithoutChanges"] = $includeInterfacesWithoutChanges
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/interfaces/l2/statuses/changeHistory/byDevice?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}