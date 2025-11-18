function Get-MerakiOrganizationWirelessSsidsOpenRoamingByNetwork {
    <#
    .SYNOPSIS
    Retrieves Meraki OpenRoaming SSID configuration grouped by network for an organization.

    .DESCRIPTION
    Calls the Meraki Dashboard API endpoint to return OpenRoaming SSIDs organized by network for the specified organization.
    Supports pagination (perPage, startingAfter, endingBefore), filtering by one or more network IDs, and an option to include disabled SSIDs.
    Returns the deserialized JSON response from the API.

    .PARAMETER AuthToken
    API key used for authorization (sent as X-Cisco-Meraki-API-Key). Mandatory.

    .PARAMETER OrganizationID
    Meraki organization ID to query. If omitted, the function attempts to resolve the organization via Get-OrgID -AuthToken $AuthToken.
    If multiple organizations are found, the function returns a message requesting an explicit OrganizationID.

    .PARAMETER perPage
    Optional integer specifying the number of items per page for paginated responses.

    .PARAMETER startingAfter
    Optional pagination cursor. Return items after this cursor.

    .PARAMETER endingBefore
    Optional pagination cursor. Return items before this cursor.

    .PARAMETER networkIds
    Optional array of network IDs to limit results to specific networks (sent as networkIds[] query parameter).

    .PARAMETER includeDisabledSsids
    Optional boolean. If true, include disabled SSIDs in the returned results.

    .EXAMPLE
    Get-MerakiOrganizationWirelessSsidsOpenRoamingByNetwork -AuthToken 'abcdef123456' -OrganizationID '123456'

    .NOTES
    - Requires network access to api.meraki.com.
    - Throws a terminating error if the REST call fails.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore,
        [parameter(Mandatory=$false)]
        [array]$networkIds,
        [parameter(Mandatory=$false)]
        [bool]$includeDisabledSsids
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try { 
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $queryParams = @{}
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
            If ($includeDisabledSsids -ne $null) { 
                $queryParams["includeDisabledSsids"] = $includeDisabledSsids
            }
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/ssids/openRoaming/byNetwork?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}