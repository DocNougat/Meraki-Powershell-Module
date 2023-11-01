function Get-MerakiOrganizationAdmins {
    <#
    .SYNOPSIS
    Retrieves a list of administrators in the specified organization.

    .DESCRIPTION
    The Get-MerakiOrganizationAdmins function retrieves a list of administrators in the specified Meraki organization. This function requires a valid API key to be passed in as a parameter.

    .PARAMETER AuthToken
    The Meraki API token to use for authentication.

    .PARAMETER OrgID
    The ID of the organization to retrieve administrators from. If not specified, the function will retrieve administrators from the first organization associated with the API key.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdmins -AuthToken "12345" -OrgID "67890"
    Retrieves a list of administrators in the organization with ID "67890", using the API key "12345" for authentication.

    .NOTES
    For more information on the Meraki API, see the official documentation at https://developer.cisco.com/meraki/api-v1/.
    #>

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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/admins" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}
