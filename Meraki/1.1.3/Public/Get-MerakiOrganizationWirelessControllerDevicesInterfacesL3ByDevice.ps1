function Get-MerakiOrganizationWirelessControllerDevicesInterfacesL3ByDevice {
    <#
    .SYNOPSIS
    Retrieves Layer 3 interface information for wireless controller devices in a Meraki organization, grouped by device.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint GET /organizations/{organizationId}/wirelessController/devices/interfaces/l3/byDevice and returns the parsed JSON response.
    This helper wraps authentication, query parameter construction, and URI escaping. Supports time-range filtering, pagination, and filtering by device serials.

    .PARAMETER AuthToken
    (Required) The Meraki API key used for authentication. Sent in the "X-Cisco-Meraki-API-Key" header.

    .PARAMETER OrganizationID
    (Optional) The Meraki organization ID. If not provided, the function attempts to discover one by calling Get-OrgID -AuthToken <AuthToken>.
    If Get-OrgID returns a message indicating multiple organizations, the function will return that message and abort; specify OrganizationID explicitly in that case.

    .PARAMETER t0
    (Optional) The beginning of the timespan for the data in ISO 8601 format (for example: 2020-01-01T00:00:00Z). When provided, events/metrics are returned from this timestamp.

    .PARAMETER t1
    (Optional) The end of the timespan for the data in ISO 8601 format. When provided, events/metrics are returned up to this timestamp.

    .PARAMETER timespan
    (Optional) A duration in seconds for how far back from now to fetch data (mutually compatible with t0/t1 depending on API semantics). If supplied, it is sent as the "timespan" query parameter.

    .PARAMETER perPage
    (Optional) Integer specifying the number of items per page for paginated results. Sent as "perPage" query parameter.

    .PARAMETER startingAfter
    (Optional) Pagination cursor. When provided, the API returns items after this cursor. Sent as "startingAfter" query parameter.

    .PARAMETER endingBefore
    (Optional) Pagination cursor. When provided, the API returns items before this cursor. Sent as "endingBefore" query parameter.

    .PARAMETER serials
    (Optional) Array of device serial numbers used to filter results to one or more specific devices. Sent as repeated "serials[]" query parameters.

    .EXAMPLE
    PS> Get-MerakiOrganizationWirelessControllerDevicesInterfacesL3ByDevice -AuthToken $token -OrganizationID "123456" -timespan 3600

    Retrieves L3 interface data for organization 123456 for the last hour.

    .LINK
    Meraki Dashboard API Documentation: https://developer.cisco.com/meraki/api-v1/
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wirelessController/devices/interfaces/l3/byDevice?$queryString"

            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}