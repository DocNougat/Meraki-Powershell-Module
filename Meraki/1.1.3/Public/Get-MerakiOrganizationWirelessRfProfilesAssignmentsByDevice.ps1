function Get-MerakiOrganizationWirelessRfProfilesAssignmentsByDevice {
    <#
    .SYNOPSIS
    Retrieves the RF profile assignments by device for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve the RF profile assignments by device for a specified organization by providing the authentication token, organization ID, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 1000. Default is 1000.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page.

    .PARAMETER NetworkIds
    Optional parameter to filter devices by network.

    .PARAMETER ProductTypes
    Optional parameter to filter devices by product type.

    .PARAMETER Name
    Optional parameter to filter RF profiles by device name.

    .PARAMETER Mac
    Optional parameter to filter RF profiles by device MAC address.

    .PARAMETER Serial
    Optional parameter to filter RF profiles by device serial number.

    .PARAMETER Model
    Optional parameter to filter RF profiles by device model.

    .PARAMETER Macs
    Optional parameter to filter RF profiles by one or more device MAC addresses.

    .PARAMETER Serials
    Optional parameter to filter RF profiles by one or more device serial numbers.

    .PARAMETER Models
    Optional parameter to filter RF profiles by one or more device models.

    .EXAMPLE
    Get-MerakiOrganizationWirelessRfProfilesAssignmentsByDevice -AuthToken "your-api-token" -OrganizationId "123456" -PerPage 500 -NetworkIds @("N_123", "N_456") -ProductTypes @("wireless")

    This example retrieves the RF profile assignments by device for the specified organization and filters by network IDs and product types, returning 500 entries per page.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$PerPage = 1000,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore,
        [parameter(Mandatory=$false)]
        [string[]]$NetworkIds,
        [parameter(Mandatory=$false)]
        [string[]]$ProductTypes,
        [parameter(Mandatory=$false)]
        [string]$Name,
        [parameter(Mandatory=$false)]
        [string]$Mac,
        [parameter(Mandatory=$false)]
        [string]$Serial,
        [parameter(Mandatory=$false)]
        [string]$Model,
        [parameter(Mandatory=$false)]
        [string[]]$Macs,
        [parameter(Mandatory=$false)]
        [string[]]$Serials,
        [parameter(Mandatory=$false)]
        [string[]]$Models
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $queryParams = @{
                perPage = $PerPage
            }

            if ($StartingAfter) {
                $queryParams['startingAfter'] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams['endingBefore'] = $EndingBefore
            }

            if ($NetworkIds) {
                $queryParams['networkIds'] = ($NetworkIds -join ",")
            }

            if ($ProductTypes) {
                $queryParams['productTypes'] = ($ProductTypes -join ",")
            }

            if ($Name) {
                $queryParams['name'] = $Name
            }

            if ($Mac) {
                $queryParams['mac'] = $Mac
            }

            if ($Serial) {
                $queryParams['serial'] = $Serial
            }

            if ($Model) {
                $queryParams['model'] = $Model
            }

            if ($Macs) {
                $queryParams['macs'] = ($Macs -join ",")
            }

            if ($Serials) {
                $queryParams['serials'] = ($Serials -join ",")
            }

            if ($Models) {
                $queryParams['models'] = ($Models -join ",")
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/rfProfiles/assignments/byDevice?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}