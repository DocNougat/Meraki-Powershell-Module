function Get-MerakiOrganizationWirelessSsidsStatusesByDevice {
    <#
    .SYNOPSIS
    Retrieves the status of SSIDs by device for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve the status of SSIDs by device for a specified organization by providing the authentication token, organization ID, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER NetworkIds
    Optional parameter to filter the result set by the included set of network IDs.

    .PARAMETER Serials
    A list of serial numbers. The returned devices will be filtered to only include these serials.

    .PARAMETER Bssids
    A list of BSSIDs. The returned devices will be filtered to only include these BSSIDs.

    .PARAMETER HideDisabled
    If true, the returned devices will not include disabled SSIDs. (default: true)

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 500. Default is 100.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page.

    .EXAMPLE
    Get-MerakiOrganizationWirelessSsidsStatusesByDevice -AuthToken "your-api-token" -OrganizationId "123456" -NetworkIds @("N_123", "N_456") -Serials @("Q2XX-XXXX-XXXX") -HideDisabled $true -PerPage 100

    This example retrieves the status of SSIDs by device for the specified organization and filters by network IDs and serials, hiding disabled SSIDs and returning 100 entries per page.

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
        [string[]]$NetworkIds,
        [parameter(Mandatory=$false)]
        [string[]]$Serials,
        [parameter(Mandatory=$false)]
        [string[]]$Bssids,
        [parameter(Mandatory=$false)]
        [bool]$HideDisabled = $true,
        [parameter(Mandatory=$false)]
        [int]$PerPage = 100,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore
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
                hideDisabled = $HideDisabled
                perPage = $PerPage
            }

            if ($NetworkIds) {
                $queryParams['networkIds'] = ($NetworkIds -join ",")
            }

            if ($Serials) {
                $queryParams['serials'] = ($Serials -join ",")
            }

            if ($Bssids) {
                $queryParams['bssids'] = ($Bssids -join ",")
            }

            if ($StartingAfter) {
                $queryParams['startingAfter'] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams['endingBefore'] = $EndingBefore
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/ssids/statuses/byDevice?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}