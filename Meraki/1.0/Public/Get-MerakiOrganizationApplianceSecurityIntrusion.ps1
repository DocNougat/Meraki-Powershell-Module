function Get-MerakiOrganizationApplianceSecurityIntrusion {
    <#
    .SYNOPSIS
    Retrieves the intrusion settings for the security appliance of a specified Meraki organization.

    .DESCRIPTION
    This function retrieves the intrusion settings for the security appliance of a specified Meraki organization using the Meraki Dashboard API. It requires an authentication token with the necessary permissions to access the API.

    .PARAMETER AuthToken
    The authentication token required to access the Meraki Dashboard API. You can obtain this token from your Meraki Dashboard account.

    .PARAMETER OrgId
    The ID of the Meraki organization for which to retrieve the intrusion settings. If not specified, the function will retrieve the ID of the first organization associated with the authentication token.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceSecurityIntrusion -AuthToken "12345" -OrgId "56789"
    Retrieves the intrusion settings for the security appliance of the Meraki organization with ID "56789".

    .NOTES
    This function requires the Invoke-RestMethod cmdlet to be available in the PowerShell session.
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
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/security/intrusion" -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}
