function Get-MerakiOrganizationWirelessAirMarshalSettingsByNetwork {
    <#
    .SYNOPSIS
    Retrieves Air Marshal settings by network for an organization.

    .DESCRIPTION
    This function allows you to retrieve the Air Marshal settings by network for an organization by providing the authentication token, organization ID, and optional query parameters for filtering and pagination.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER NetworkIds
    The network IDs to include in the result set.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 1000. Default is 1000.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page. Often this is a timestamp or an ID but it is not limited to those.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page. Often this is a timestamp or an ID but it is not limited to those.

    .EXAMPLE
    Get-MerakiOrganizationWirelessAirMarshalSettingsByNetwork -AuthToken "your-api-token" -OrganizationId "123456" -NetworkIds "N_123456789012345678"

    This example retrieves the Air Marshal settings by network for the organization with ID "123456".
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
        [int]$PerPage = 1000,
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

            $queryParams = @{}

            if ($NetworkIds) {
                $queryParams['networkIds'] = $NetworkIds  -join ","
            }

            if ($PerPage) {
                $queryParams['perPage'] = $PerPage
            }

            if ($StartingAfter) {
                $queryParams['startingAfter'] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams['endingBefore'] = $EndingBefore
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/airMarshal/settings/byNetwork?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}