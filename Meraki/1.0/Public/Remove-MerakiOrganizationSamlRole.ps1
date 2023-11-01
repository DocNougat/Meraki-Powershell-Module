function Remove-MerakiOrganizationSamlRole {
    <#
    .SYNOPSIS
    Deletes an existing SAML role for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationSamlRole function allows you to delete an existing SAML role for a specified Meraki organization by providing the authentication token, organization ID, and SAML role ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete a SAML role.

    .PARAMETER SAMLRoleId
    The ID of the SAML role you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationSamlRole -AuthToken "your-api-token" -OrganizationId "1234567890" -SAMLRoleId "5678"

    This example deletes the SAML role with ID "5678" for the Meraki organization with ID "1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$true)]
        [string]$SAMLRoleId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/samlRoles/$SAMLRoleId"

        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
        return $response
    }
    catch {
        Write-Host $_
    }
}