function Remove-MerakiOrganizationSplashTheme {
    <#
    .SYNOPSIS
    Deletes a splash theme for the specified organization.

    .DESCRIPTION
    This function allows you to delete a splash theme for a specified organization by providing the authentication token, organization ID, and theme ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER ThemeId
    The ID of the splash theme to delete.

    .EXAMPLE
    Remove-MerakiOrganizationSplashTheme -AuthToken "your-api-token" -OrganizationId "123456" -ThemeId "theme_id"

    This example deletes the splash theme with ID "theme_id" for the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ThemeId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/splash/themes/$ThemeId"

            $response = Invoke-RestMethod -Method Delete -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}