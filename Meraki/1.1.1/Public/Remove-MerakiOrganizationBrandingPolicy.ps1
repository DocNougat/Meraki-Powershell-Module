function Remove-MerakiOrganizationBrandingPolicy {
    <#
    .SYNOPSIS
    Deletes an existing branding policy for a Meraki organization using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiOrganizationBrandingPolicy function allows you to delete an existing branding policy for a specified Meraki organization by providing the authentication token, organization ID, and branding policy ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to delete a branding policy.

    .PARAMETER BrandingPolicyId
    The ID of the branding policy to be deleted.

    .EXAMPLE
    Remove-MerakiOrganizationBrandingPolicy -AuthToken "your-api-token" -OrganizationId "1234567890" -BrandingPolicyId "1234567890"

    This example deletes the branding policy with ID "1234567890" for the Meraki organization with ID "1234567890".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$BrandingPolicyId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
            
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/brandingPolicies/$BrandingPolicyId"
            
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}