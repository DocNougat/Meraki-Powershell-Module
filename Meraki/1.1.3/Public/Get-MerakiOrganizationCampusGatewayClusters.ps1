function Get-MerakiOrganizationCampusGatewayClusters {
    <#
    .SYNOPSIS
    Retrieves campus gateway cluster objects for a specified Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationCampusGatewayClusters queries the Meraki Dashboard API endpoint
    /organizations/{organizationId}/campusGateway/clusters and returns cluster objects for
    the organization. The function sends the provided API key in the X-Cisco-Meraki-API-Key
    header, supports optional network filtering and cursor-based pagination, and returns
    the deserialized JSON response from the API.

    .PARAMETER AuthToken
    [string] REQUIRED
    The Meraki Dashboard API key used for authentication. Supplied value is sent in the
    X-Cisco-Meraki-API-Key request header.

    .PARAMETER OrganizationID
    [string] Optional
    The organization ID to query. If not supplied, the function attempts to determine the
    organization ID by calling Get-OrgID -AuthToken $AuthToken. If multiple organizations
    are present and no specific ID is provided, the function returns the message:
    "Multiple organizations found. Please specify an organization ID."

    .PARAMETER networkIds
    [array] Optional
    One or more network ID strings to restrict the returned clusters to the specified
    networks. When provided, the function adds networkIds to the query string (array form
    is preserved).

    .PARAMETER perPage
    [int] Optional
    Requested number of results per page (if supported by the API). When supplied, the
    value is added to the query string as perPage for pagination control.

    .PARAMETER startingAfter
    [string] Optional
    Cursor value indicating the page token to start after. When supplied, the value is
    added to the query string as startingAfter for cursor-based pagination.

    .PARAMETER endingBefore
    [string] Optional
    Cursor value indicating the page token to end before. When supplied, the value is
    added to the query string as endingBefore for cursor-based pagination.

    .EXAMPLE
    # Retrieve all campus gateway clusters for a known organization
    Get-MerakiOrganizationCampusGatewayClusters -AuthToken 'ABCDEF123456' -OrganizationID '123456'

    .EXAMPLE
    # Retrieve clusters for specific networks with pagination
    Get-MerakiOrganizationCampusGatewayClusters -AuthToken $env:MERAKI_KEY -OrganizationID '123456' -networkIds @('N_1','N_2') -perPage 50 -startingAfter 'token123'

    .NOTES
    - The function builds a query string from supplied parameters and URL-encodes the final URI.
    - Uses user agent "MerakiPowerShellModule/1.1.3 DocNougat".
    - Errors raised by the REST call are written to debug and re-thrown to the caller.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [Parameter(Mandatory=$false)]
        [array]$networkIds,
        [Parameter(Mandatory=$false)]
        [int]$perPage,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $queryParams = @{}
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($perPage) {
                    $queryParams['perPage'] = $perPage
            }
            if ($startingAfter) {
                    $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                    $queryParams['endingBefore'] = $endingBefore
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/campusGateway/clusters?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
