function Get-MerakiOrganizationWirelessAirMarshalRules {
    <#
    .SYNOPSIS
    Retrieves Air Marshal rules for an organization.

    .DESCRIPTION
    This function allows you to retrieve Air Marshal rules for an organization by providing the authentication token and organization ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER NetworkIds
    Optional parameter to filter rules by network IDs.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 1000. Default is 1000.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page.

    .EXAMPLE
    Get-MerakiOrganizationWirelessAirMarshalRules -AuthToken "your-api-token" -OrganizationId "123456"

    This example retrieves the Air Marshal rules for the organization with ID "123456".
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

            $queryParams = @{
                "perPage" = $PerPage
            }

            if ($NetworkIds) {
                $queryParams["networkIds"] = $NetworkIds -join ","
            }

            if ($StartingAfter) {
                $queryParams["startingAfter"] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams["endingBefore"] = $EndingBefore
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/wireless/airMarshal/rules?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}