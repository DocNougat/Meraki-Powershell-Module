function Get-MerakiOrganizationWirelessDevicesPowerModeHistory {
    <#
    .SYNOPSIS
    Retrieves the power mode history for wireless devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationWirelessDevicesPowerModeHistory queries the Meraki Dashboard API
    endpoint /organizations/{organizationId}/wireless/devices/power/mode/history and returns
    history records of device power mode changes. The function builds query parameters
    from the provided arguments, supports filtering by time range, specific networks or
    serials, and supports pagination parameters returned by the Meraki API.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request.
    This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If not supplied, the function attempts to
    resolve it by calling Get-OrgID -AuthToken <AuthToken>. If multiple organizations
    are found, the function will return a prompt string instructing to specify an ID.

    .PARAMETER t0
    Start of the timespan for the query in ISO 8601 format (e.g. 2021-01-01T00:00:00Z).
    Optional. When supplied, records at or after this time are returned.

    .PARAMETER t1
    End of the timespan for the query in ISO 8601 format. Optional. When supplied,
    records at or before this time are returned.

    .PARAMETER timespan
    Length of the timespan in seconds from now to query. If specified, t0 and t1 are ignored.
    Optional.

    .PARAMETER perPage
    Number of entries per page to request from the API. Optional. Use in conjunction
    with pagination parameters returned by the API.

    .PARAMETER startingAfter
    Pagination cursor to start listing after the provided value. Optional.

    .PARAMETER endingBefore
    Pagination cursor to end listing before the provided value. Optional.

    .PARAMETER networkIds
    Array of network IDs to filter results to only those networks.
    Each value is sent as networkIds[] query parameter. Optional.

    .PARAMETER serials
    Array of device serial numbers to filter results to only those devices.
    Each value is sent as serials[] query parameter. Optional.

    .EXAMPLE
    # Retrieve power mode history for an organization using a token and explicit Org ID
    Get-MerakiOrganizationWirelessDevicesPowerModeHistory -AuthToken $token -OrganizationID "123456"

    .NOTES
    - The function calls the Meraki API v1 endpoint:
        https://api.meraki.com/api/v1/organizations/{organizationId}/wireless/devices/power/mode/history
    - Time parameters t0 and t1 should be ISO 8601 formatted strings. timespan is specified in seconds.
    - When passing multiple network IDs or serials, supply arrays.
    - Ensure the AuthToken has appropriate dashboard API permissions for the target organization.
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
            If ($networkIds) { 
                $queryParams["networkIds[]"] = $networkIds
            }
            If ($serials) { 
                $queryParams["serials[]"] = $serials
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/devices/power/mode/history?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}