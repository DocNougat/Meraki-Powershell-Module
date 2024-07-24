function Get-MerakiOrganizationBrandingPolicy {
    <#
    .SYNOPSIS
    Retrieves a branding policy for a Meraki organization.

    .DESCRIPTION
    This function retrieves a branding policy for a Meraki organization using the Meraki Dashboard API. It requires an authentication token for the API, the ID of the branding policy to be retrieved, and the ID of the organization to which the policy belongs.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER BrandingPolicyID
    The ID of the branding policy to be retrieved.

    .PARAMETER OrgID
    The ID of the organization to which the branding policy belongs. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationBrandingPolicy -AuthToken $AuthToken -BrandingPolicyID $BrandingPolicyID -OrgID $OrganizationID

    Retrieves the specified branding policy for the specified organization.

    .NOTES
    This function requires the Get-MerakiOrganizations function.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-branding-policy
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$BrandingPolicyID,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/brandingPolicies/$BrandingPolicyID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
