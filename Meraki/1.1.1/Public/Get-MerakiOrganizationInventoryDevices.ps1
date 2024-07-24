function Get-MerakiOrganizationInventoryDevices {
    <#
    .SYNOPSIS
    Retrieves a list of Meraki device inventory items for a specified organization.

    .DESCRIPTION
    This function retrieves a list of Meraki device inventory items for a specified organization using the Meraki Dashboard API. The authentication token and organization ID are required for this operation. Additional filters can be applied to narrow down the list of devices returned.

    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki Dashboard API.

    .PARAMETER OrgID
    Specifies the ID of the Meraki organization. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .PARAMETER perPage
    Specifies the number of inventory items to return per page.

    .PARAMETER startingAfter
    Returns results starting after the provided inventory item ID.

    .PARAMETER endingBefore
    Returns results ending before the provided inventory item ID.

    .PARAMETER usedState
    Filters the results by device used state (used, unused, or both).

    .PARAMETER search
    Searches for inventory items by serial number, MAC address, model, or network ID.

    .PARAMETER macs
    Filters the results by MAC address.

    .PARAMETER networkIds
    Filters the results by network ID.

    .PARAMETER serials
    Filters the results by serial number.

    .PARAMETER models
    Filters the results by model.

    .PARAMETER tags
    Filters the results by tag.

    .PARAMETER tagsFilterType
    Specifies the filter type for the tags parameter (and/or).

    .PARAMETER productTypes
    Filters the results by product type.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationInventoryDevices -AuthToken "12345" -OrgId "123456" -search "MX"

    Retrieves a list of Meraki device inventory items for the organization with ID "123456" that match the search term "MX" using the authentication token "12345".
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
        [string]$usedState = $null,
        [parameter(Mandatory=$false)]
        [string]$search = $null,
        [parameter(Mandatory=$false)]
        [array]$macs = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null,
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$models = $null,
        [parameter(Mandatory=$false)]
        [array]$tags = $null,
        [parameter(Mandatory=$false)]
        [string]$tagsFilterType = $null,
        [parameter(Mandatory=$false)]
        [array]$productTypes = $null
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
            if ($usedState) {
                $queryParams['usedState'] = $usedState
            }
            if ($search) {
                $queryParams['search'] = $search
            }
            if ($macs) {
                $queryParams['macs[]'] = $macs
            }
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($models) {
                $queryParams['models[]'] = $models
            }
            if ($tags) {
                $queryParams['tags[]'] = $tags
            }
            if ($tagsFilterType) {
                $queryParams['tagsFilterType'] = $tagsFilterType
            }
            if ($productTypes) {
                $queryParams['productTypes[]'] = $productTypes
            }
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/inventory/devices?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}