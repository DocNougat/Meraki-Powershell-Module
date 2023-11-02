function Get-MerakiOrganizationBrandingPoliciesPriorities {
    <#
    .SYNOPSIS
    Retrieves branding policy priorities for a Meraki organization.

    .DESCRIPTION
    This function retrieves branding policy priorities for a Meraki organization using the Meraki Dashboard API. It requires an authentication token for the API, and the ID of the organization for which the branding policy priorities should be retrieved.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrgID
    The ID of the organization for which the branding policy priorities should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationBrandingPoliciesPriorities -AuthToken $AuthToken -OrgID $OrganizationID

    Retrieves branding policy priorities for the specified organization.

    .NOTES
    This function requires the Get-MerakiOrganizations function.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-branding-policies-priorities

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
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/brandingPolicies/priorities" -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}