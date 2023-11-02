function Remove-MerakiOrganizationSAMLIdp {
    <#
    .SYNOPSIS
    Deletes an existing SAML IdP for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationSamlIdp function allows you to delete an existing SAML IdP for a specified Meraki organization by providing the authentication token, organization ID, and IdP ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete a SAML IdP.

    .PARAMETER IdpId
    The ID of the SAML IdP you want to delete.

    .EXAMPLE
    Remove-MerakiOrganizationSamlIdp -AuthToken "your-api-token" -OrganizationId "1234567890" -IdpId "5678"

    This example deletes the SAML IdP with ID "5678" for the Meraki organization with ID "1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$IdpId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/saml/idps/$IdpId"
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header
            return $response
        }
        catch {
            Write-Host $_
        }
    }
}