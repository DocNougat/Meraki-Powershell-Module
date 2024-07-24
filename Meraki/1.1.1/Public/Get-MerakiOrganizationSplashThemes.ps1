function Get-MerakiOrganizationSplashThemes {
    <#
    .SYNOPSIS
    Retrieves the list of splash themes for the specified organization.

    .DESCRIPTION
    This function allows you to retrieve the list of splash themes for a specified organization by providing the authentication token and organization ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .EXAMPLE
    Get-MerakiOrganizationSplashThemes -AuthToken "your-api-token" -OrganizationId "123456"

    This example retrieves the list of splash themes for the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
        } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/splash/themes"

            $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}