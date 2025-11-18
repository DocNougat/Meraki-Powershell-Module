function Get-MerakiOrganizationDevicesProvisioningStatuses {
    <#
    .SYNOPSIS
    Retrieves provisioning statuses for devices in a Meraki organization.

    .DESCRIPTION
    Gets the provisioning status information for devices belonging to a specified Meraki organization using the Meraki Dashboard API.
    Supports pagination and multiple filter options (network IDs, product types, serials, status, tags, and tag filter type).
    If multiple organizations are found by the helper Get-OrgID, the function requires an explicit OrganizationID to be provided.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This is required.

    .PARAMETER OrganizationID
    The unique identifier of the Meraki organization to query. If not provided, the function attempts to resolve the organization ID using Get-OrgID -AuthToken $AuthToken.
    If Get-OrgID returns "Multiple organizations found. Please specify an organization ID.", the function will return that message and stop.

    .PARAMETER perPage
    (Optional) The number of items to return per page. When provided, the function includes this as the perPage query parameter for pagination.

    .PARAMETER startingAfter
    (Optional) Pagination cursor. Return results starting after the provided cursor (value from previous response).

    .PARAMETER endingBefore
    (Optional) Pagination cursor. Return results ending before the provided cursor (value from previous response).

    .PARAMETER networkIds
    (Optional) Array of network IDs to filter results by. If supplied, each value is added to the query as networkIds[].

    .PARAMETER productTypes
    (Optional) Array of product types to filter results by (e.g. "ap", "switch", "camera"). If supplied, each value is added to the query as productTypes[].

    .PARAMETER serials
    (Optional) Array of device serial numbers to filter results by. If supplied, each value is added to the query as serials[].

    .PARAMETER status
    (Optional) Filter results by provisioning status (string). Typical values depend on the API ("complete", "incomplete", "unprovisioned").

    .PARAMETER tags
    (Optional) Array of tags to filter results by. If supplied, each value is added to the query as tags[].

    .PARAMETER tagsFilterType
    (Optional) Specifies how to match tags when multiple are provided ("withAllTags", "withAnyTags"). Check the Meraki API documentation for supported values.

    .EXAMPLE
    PS> Get-MerakiOrganizationDevicesProvisioningStatuses -AuthToken $token -OrganizationID "123456" -perPage 100
    Retrieve up to 100 device provisioning status entries for organization 123456.

    .NOTES
    - Requires a valid Meraki API key (passed via -AuthToken).
    - Errors from the REST call are thrown to the caller; use try/catch when calling this function to handle failures.
    - Refer to the Meraki Dashboard API documentation for the most current parameter semantics and valid status/tagFilterType values.
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
        [array]$productTypes = $null,
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [string]$status = $null,
        [parameter(Mandatory=$false)]
        [array]$tags = $null,
        [parameter(Mandatory=$false)]
        [string]$tagsFilterType = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        Try { 
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
            if ($productTypes) {
                $queryParams['productTypes[]'] = $productTypes
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($status) {
                $queryParams['status'] = $status
            }
            if ($tags) {
                $queryParams['tags[]'] = $tags
            }
            if ($tagsFilterType) {
                $queryParams['tagsFilterType'] = $tagsFilterType
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/provisioning/statuses?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
            Write-Debug $_
            Throw $_
        }
    }
}