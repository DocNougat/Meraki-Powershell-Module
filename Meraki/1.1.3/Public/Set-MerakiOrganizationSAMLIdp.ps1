function Set-MerakiOrganizationSAMLIdp {
    <#
    .SYNOPSIS
    Updates an existing SAML IdP for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationSAMLIdp function allows you to update an existing SAML IdP for a specified Meraki organization by providing the authentication token, organization ID, IdP ID, and a JSON configuration for the SAML IdP.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update a SAML IdP.

    .PARAMETER IdpId
    The ID of the SAML IdP you want to update.

    .PARAMETER SAMLIdpConfig
    The JSON configuration for the SAML IdP to be updated. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $SAMLIdpConfig = [PSCustomObject]@{
        x509certSha1Fingerprint = "00:11:22:33:44:55:66:77:88:99:00:11:22:33:44:55:66:77:88:99"
        sloLogoutUrl = "https://somewhere.com"
    }

    $SAMLIdpConfig = $SAMLIdpConfig | ConvertTo-Json -Compress -Depth 4

    Set-MerakiOrganizationSAMLIdp -AuthToken "your-api-token" -OrganizationId "1234567890" -IdpId "5678" -SAMLIdpConfig $SAMLIdpConfig

    This example updates the SAML IdP with ID "5678" for the Meraki organization with ID "1234567890". The SAML IdP is configured with a SHA1 fingerprint of "00:11:22:33:44:55:66:77:88:99:00:11:22:33:44:55:66:77:88:99" and a single logout URL of "https://somewhere.com".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$IdpId,
        [parameter(Mandatory=$true)]
        [string]$SAMLIdpConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = $SAMLIdpConfig

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/saml/idps/$IdpId"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}