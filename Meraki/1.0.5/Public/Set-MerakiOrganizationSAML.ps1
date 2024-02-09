function Set-MerakiOrganizationSAML {
    <#
    .SYNOPSIS
    Updates the SAML SSO settings for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiOrganizationSAML function allows you to update the SAML SSO settings for a specified Meraki organization by providing the authentication token, organization ID, and a boolean value for the SAML SSO enabled setting.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the SAML SSO settings.

    .PARAMETER SAMLEnabled
    A boolean value indicating whether SAML SSO should be enabled or disabled for the organization.

    .EXAMPLE
    Set-MerakiOrganizationSAML -AuthToken "your-api-token" -OrganizationId "1234567890" -SAMLEnabled $true

    This example enables SAML SSO for the Meraki organization with ID "1234567890".

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
        [bool]$SAMLEnabled
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $body = @{
                "enabled" = $SAMLEnabled
            } | ConvertTo-Json -Compress

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/saml"
            
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }
}