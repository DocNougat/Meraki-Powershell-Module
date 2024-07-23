function Get-MerakiOrganizationSmSentryPoliciesAssignmentsByNetwork {
    <#
    .SYNOPSIS
    Retrieves Sentry Policies assignments by network for an organization.

    .DESCRIPTION
    This function allows you to retrieve Sentry Policies assignments by network for an organization by providing the authentication token, organization ID, and optional query parameters for pagination and filtering by network IDs.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 1000. Default is 50.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page. Often this is a timestamp or an ID but it is not limited to those.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page. Often this is a timestamp or an ID but it is not limited to those.

    .PARAMETER NetworkIds
    Optional parameter to filter Sentry Policies by Network ID.

    .EXAMPLE
    Get-MerakiOrganizationSmSentryPoliciesAssignmentsByNetwork -AuthToken "your-api-token" -OrganizationId "123456" -PerPage 100

    This example retrieves Sentry Policies assignments by network for the organization with ID "123456" with up to 100 entries per page.

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
        [int]$PerPage = 50,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore,
        [parameter(Mandatory=$false)]
        [string[]]$NetworkIds
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

            if ($PerPage) {
                $queryParams['perPage'] = $PerPage
            }

            if ($StartingAfter) {
                $queryParams['startingAfter'] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams['endingBefore'] = $EndingBefore
            }

            if ($NetworkIds) {
                $queryParams['networkIds'] = $NetworkIds -join ","
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/sm/sentry/policies/assignments/byNetwork?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}