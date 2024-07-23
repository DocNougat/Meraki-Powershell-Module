function Get-MerakiOrganizationSmAdminsRoles {
    <#
    .SYNOPSIS
    Retrieves a list of Limited Access Roles for administrators in an organization.

    .DESCRIPTION
    This function allows you to retrieve a list of Limited Access Roles for administrators in a given organization by providing the authentication token, organization ID, and optional query parameters for pagination.

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

    .EXAMPLE
    Get-MerakiOrganizationSmAdminsRoles -AuthToken "your-api-token" -OrganizationId "123456" -PerPage 100

    This example retrieves a list of Limited Access Roles for administrators in the organization with ID "123456" with up to 100 entries per page.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$PerPage = 50,
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

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/sm/admins/roles?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}