function Get-MerakiOrganizationAlertsProfiles {
    <#
    .SYNOPSIS
    Retrieves the list of alert profiles for a specified Meraki organization.

    .DESCRIPTION
    This function retrieves the list of alert profiles for a specified Meraki organization using the Meraki Dashboard API. It requires an authentication token with the necessary permissions to access the API.

    .PARAMETER AuthToken
    The authentication token required to access the Meraki Dashboard API. You can obtain this token from your Meraki Dashboard account.

    .PARAMETER OrgID
    The ID of the Meraki organization for which to retrieve the list of alert profiles. If not specified, the function will retrieve the ID of the first organization associated with the authentication token.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAlertsProfiles -AuthToken "12345" -OrgID "56789"
    Retrieves the list of alert profiles for the Meraki organization with ID "56789".

    .NOTES
    This function requires the Invoke-RestMethod cmdlet to be available in the PowerShell session.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-MerakiOrganizations -AuthToken $AuthToken).id
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $uri = "https://api.meraki.com/api/v1/organizations/$OrganizationID/alerts/profiles"
        $response = Invoke-RestMethod -Method Get -Uri $uri -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}
