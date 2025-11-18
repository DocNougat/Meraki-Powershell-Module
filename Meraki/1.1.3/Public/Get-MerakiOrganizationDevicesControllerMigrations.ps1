function Get-MerakiOrganizationDevicesControllerMigrations {
    <#
    .SYNOPSIS
    Retrieves controller migration records for devices in a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationDevicesControllerMigrations queries the Meraki Dashboard API to return controller migration information for devices belonging to a specified organization. The function builds a GET request to the endpoint:
    https://api.meraki.com/api/v1/organizations/{organizationId}/devices/controller/migrations
    and supports optional pagination and filtering (by serials, network IDs, and target).

    .PARAMETER AuthToken
    [string] Mandatory.
    API key used to authenticate to the Meraki Dashboard API. Sent in the X-Cisco-Meraki-API-Key header.

    .PARAMETER OrganizationID
    [string] Optional.
    The Meraki organization ID to query. If not provided, the function attempts to resolve an organization via Get-OrgID -AuthToken $AuthToken. If multiple organizations are found, the helper may return the message: "Multiple organizations found. Please specify an organization ID." In that case, pass an explicit OrganizationID.

    .PARAMETER perPage
    [int] Optional.
    Number of items to return per page. Maps to the perPage query parameter.

    .PARAMETER startingAfter
    [string] Optional.
    Pagination cursor to return results starting after this value. Maps to the startingAfter query parameter.

    .PARAMETER endingBefore
    [string] Optional.
    Pagination cursor to return results ending before this value. Maps to the endingBefore query parameter.

    .PARAMETER serials
    [array] Optional.
    Array of device serial numbers to filter the results. Sent as serials[] query parameters.

    .PARAMETER networkIDs
    [array] Optional.
    Array of network IDs to filter the results. Sent as networkIDs[] query parameters.

    .PARAMETER target
    [string] Optional.
    Target controller identifier to filter migrations by the migration target. Maps to the target query parameter.

    .EXAMPLE
    # Retrieve migrations filtered by serials and limited to 50 per page
    Get-MerakiOrganizationDevicesControllerMigrations -AuthToken $AuthToken -OrganizationID $orgId -serials @("Q2XX-XXXX-XXXX","ABC1-2345-6789") -perPage 50

    .NOTES
    - Endpoint: /organizations/{organizationId}/devices/controller/migrations
    - The function will write debug information on error and rethrow the exception; callers should handle exceptions as needed.
    - When constructing query parameters for arrays, keys are sent as serials[] and networkIDs[] to match the API's expected format.

    .LINK
    https://developer.cisco.com/meraki/api-v1/ (Refer to the Meraki Dashboard API documentation for the controller migrations resource for up-to-date details.)
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
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIDs = $null,
        [parameter(Mandatory=$false)]
        [string]$target = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try{
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
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($networkIDs) {
                $queryParams['networkIDs[]'] = $networkIDs
            }
            if ($target) {
                $queryParams['target'] = $target
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/controller/migrations?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}