function Get-MerakiOrganizationDevicesUplinksAddressesByDevice {
    <#
    .SYNOPSIS
    Gets the uplink addresses of devices in a Meraki organization.

    .DESCRIPTION
    This function retrieves the uplink addresses of devices in a Meraki organization. You can filter the results by specifying various parameters.

    .PARAMETER AuthToken
    The API key for accessing the Meraki dashboard.

    .PARAMETER OrgId
    The ID of the organization to retrieve devices from. If not specified, the ID of the first organization associated with the API key will be used.

    .PARAMETER perPage
    The number of entries per page to return.

    .PARAMETER startingAfter
    The starting device serial for the list of devices returned. Used for pagination.

    .PARAMETER endingBefore
    The ending device serial for the list of devices returned. Used for pagination.

    .PARAMETER networkIds
    An array of network IDs to filter the results by.

    .PARAMETER productTypes
    An array of product types to filter the results by.

    .PARAMETER serials
    An array of device serials to filter the results by.

    .PARAMETER tags
    An array of tags to filter the results by.

    .PARAMETER tagsFilterType
    The type of tag filtering to use. Can be "withAnyTags" or "withAllTags".

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationDevicesUplinksAddressesByDevice -AuthToken "1234567890abcdef" -networkIds "N_1234567890abcdef", "N_0987654321zyxwvu"

    This example retrieves the uplink addresses of devices in the specified networks.

    .NOTES
    This function requires the Meraki PowerShell module to be installed. You can install it with the following command:

    Install-Module -Name Cisco.Meraki

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organizations-organization-id-devices-uplinks-addresses-by-device
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
        [array]$tags = $null,
        [parameter(Mandatory=$false)]
        [string]$tagsFilterType = $null
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
            if ($productTypes) {
                $queryParams['productTypes[]'] = $productTypes
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($tags) {
                $queryParams['tags[]'] = $tags
            }
            if ($tagsFilterType) {
                $queryParams['tagsFilterType'] = $tagsFilterType
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/uplinks/addresses/byDevice?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}