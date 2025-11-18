
function Get-MerakiOrganizationFloorPlansAutoLocateStatuses {
    <#
    .SYNOPSIS
    Retrieves auto-locate statuses for floor plans within a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationFloorPlansAutoLocateStatuses calls the Meraki Dashboard API to fetch the auto-locate status for one or more floor plans in the specified organization. The function supports pagination and optional filtering by network IDs and floor plan IDs. If OrganizationID is not provided, the function will attempt to resolve it using Get-OrgID with the supplied API token.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function will attempt to determine the organization ID by calling Get-OrgID with the provided AuthToken. If multiple organizations are found, the function will return a message asking for an explicit OrganizationID.

    .PARAMETER perPage
    Optional. Integer to specify the number of records per page for paginated results (page size). If not provided, the API default page size is used.

    .PARAMETER startingAfter
    Optional. A cursor value returned by a previous request to indicate the start of the next page of results.

    .PARAMETER endingBefore
    Optional. A cursor value returned by a previous request to indicate the end of the previous page of results.

    .PARAMETER networkIds
    Optional. Array of network IDs to filter results to specific networks. Example: -networkIds @('N_123','N_456')

    .PARAMETER floorPlanIds
    Optional. Array of floor plan IDs to filter results to specific floor plans. Example: -floorPlanIds @('FP_abc','FP_def')

    .EXAMPLE
    # Basic usage with explicit organization ID
    Get-MerakiOrganizationFloorPlansAutoLocateStatuses -AuthToken 'abcd1234' -OrganizationID '123456'

    .EXAMPLE
    # Paginated request to specify page size and cursor
    Get-MerakiOrganizationFloorPlansAutoLocateStatuses -AuthToken $token -OrganizationID $orgId -perPage 100 -startingAfter 'abcd_cursor'

    .EXAMPLE
    # Filter by network IDs and floor plan IDs
    Get-MerakiOrganizationFloorPlansAutoLocateStatuses -AuthToken $token -OrganizationID $orgId -networkIds @('N_1','N_2') -floorPlanIds @('FP_1')

    .NOTES
    - Requires a valid Meraki API key with sufficient privileges to read organization floor plan auto-locate statuses.
    - Calls the Meraki Dashboard API endpoint: GET /organizations/{organizationId}/floorPlans/autoLocate/statuses
    - For more details about the Meraki API endpoints and pagination semantics, see https://developer.cisco.com/meraki/api-v1/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null,
        [parameter(Mandatory=$false)]
        [array]$floorPlanIds = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "Content-Type" = "application/json"
            }
            $queryParams = @{}
            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($floorPlanIds) {
                $queryParams['floorPlanIds[]'] = $floorPlanIds
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/floorPlans/autoLocate/statuses?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}