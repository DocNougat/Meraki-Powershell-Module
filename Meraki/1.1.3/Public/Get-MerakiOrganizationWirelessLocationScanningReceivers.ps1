function Get-MerakiOrganizationWirelessLocationScanningReceivers {
    <#
    .SYNOPSIS
    Retrieves location scanning receiver devices for an organization.

    .DESCRIPTION
    Calls the Meraki API endpoint GET /organizations/{organizationId}/wireless/location/scanning/receivers to return receivers that participate in wireless location scanning for the specified organization. Supports pagination and optional filtering by one or more network IDs.

    .PARAMETER AuthToken
    The Meraki API key to authenticate the request. This header is required and must be provided as a string.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to resolve the organization ID by calling Get-OrgID with the provided AuthToken. If multiple organizations are found, the function will return an error message asking the caller to specify an organization ID.

    .PARAMETER perPage
    (Optional) Integer that controls the number of items returned per page. Use to limit page size for paginated results.

    .PARAMETER startingAfter
    (Optional) Pagination cursor. Return results starting after the provided ID.

    .PARAMETER endingBefore
    (Optional) Pagination cursor. Return results ending before the provided ID.

    .PARAMETER networkIds
    (Optional) Array of network IDs to filter results. When provided, only receivers belonging to the listed networks are returned. The parameter is passed as repeated query parameters (networkIds[]).

    .EXAMPLE
    # Use automatic organization resolution (calls Get-OrgID)
    Get-MerakiOrganizationWirelessLocationScanningReceivers -AuthToken $token

    .NOTES
    - Requires a valid Meraki API key with appropriate permissions to read organization wireless settings.
    - This function issues an HTTP GET and will throw on HTTP errors. Inspect exceptions for API error details.
    - Pagination params (perPage, startingAfter, endingBefore) follow Meraki's pagination semantics.
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
        [array]$networkIds
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
                    
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/wireless/location/scanning/receivers?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}