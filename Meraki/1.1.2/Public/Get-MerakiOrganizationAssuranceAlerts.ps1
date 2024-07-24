function Get-MerakiOrganizationAssuranceAlerts {
    <#
    .SYNOPSIS
    Retrieves assurance alerts for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve assurance alerts for a specified organization by providing the authentication token, organization ID, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 4 - 300. Default is 30.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page.

    .PARAMETER SortOrder
    Sorted order of entries. Order options are 'ascending' and 'descending'. Default is 'ascending'.

    .PARAMETER NetworkId
    Optional parameter to filter alerts by network ids.

    .PARAMETER Severity
    Optional parameter to filter by severity type.

    .PARAMETER Types
    Optional parameter to filter by alert type.

    .PARAMETER TsStart
    Optional parameter to filter by starting timestamp

    .PARAMETER TsEnd
    Optional parameter to filter by end timestamp

    .PARAMETER Category
    Optional parameter to filter by category.

    .PARAMETER SortBy
    Optional parameter to set column to sort by.

    .PARAMETER Serials
    Optional parameter to filter by primary device serial

    .PARAMETER DeviceTypes
    Optional parameter to filter by device types

    .PARAMETER DeviceTags
    Optional parameter to filter by device tags

    .PARAMETER Active
    Optional parameter to filter by active alerts. Defaults to true.

    .PARAMETER Dismissed
    Optional parameter to filter by dismissed alerts. Defaults to false.

    .PARAMETER Resolved
    Optional parameter to filter by resolved alerts. Defaults to false.

    .PARAMETER SuppressAlertsForOfflineNodes
    When set to true, the API will only return connectivity alerts for a given device if that device is in an offline state. This only applies to devices. This is ignored when resolved is true. Example: If a Switch has a VLAN Mismatch and is Unreachable, only the Unreachable alert will be returned. Defaults to false.

    .EXAMPLE
    Get-MerakiOrganizationAssuranceAlerts -AuthToken "your-api-token" -OrganizationId "123456" -PerPage 50 -SortOrder "descending"

    This example retrieves assurance alerts for the organization with ID "123456" with 50 entries per page sorted in descending order.

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
        [int]$PerPage = 30,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore,
        [parameter(Mandatory=$false)]
        [string]$SortOrder = "ascending",
        [parameter(Mandatory=$false)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [string]$Severity,
        [parameter(Mandatory=$false)]
        [string[]]$Types,
        [parameter(Mandatory=$false)]
        [string]$TsStart,
        [parameter(Mandatory=$false)]
        [string]$TsEnd,
        [parameter(Mandatory=$false)]
        [string]$Category,
        [parameter(Mandatory=$false)]
        [string]$SortBy,
        [parameter(Mandatory=$false)]
        [string[]]$Serials,
        [parameter(Mandatory=$false)]
        [string[]]$DeviceTypes,
        [parameter(Mandatory=$false)]
        [string[]]$DeviceTags,
        [parameter(Mandatory=$false)]
        [bool]$Active = $true,
        [parameter(Mandatory=$false)]
        [bool]$Dismissed = $false,
        [parameter(Mandatory=$false)]
        [bool]$Resolved = $false,
        [parameter(Mandatory=$false)]
        [bool]$SuppressAlertsForOfflineNodes = $false
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
                sortOrder = $SortOrder
                active = $Active
                dismissed = $Dismissed
                resolved = $Resolved
                suppressAlertsForOfflineNodes = $SuppressAlertsForOfflineNodes
            }

            if ($StartingAfter) {
                $queryParams['startingAfter'] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams['endingBefore'] = $EndingBefore
            }

            if ($NetworkId) {
                $queryParams['networkId'] = $NetworkId
            }

            if ($Severity) {
                $queryParams['severity'] = $Severity
            }

            if ($Types) {
                $queryParams['types'] = ($Types -join ",")
            }

            if ($TsStart) {
                $queryParams['tsStart'] = $TsStart
            }

            if ($TsEnd) {
                $queryParams['tsEnd'] = $TsEnd
            }

            if ($Category) {
                $queryParams['category'] = $Category
            }

            if ($SortBy) {
                $queryParams['sortBy'] = $SortBy
            }

            if ($Serials) {
                $queryParams['serials'] = ($Serials -join ",")
            }

            if ($DeviceTypes) {
                $queryParams['deviceTypes'] = ($DeviceTypes -join ",")
            }

            if ($DeviceTags) {
                $queryParams['deviceTags'] = ($DeviceTags -join ",")
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/assurance/alerts?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}