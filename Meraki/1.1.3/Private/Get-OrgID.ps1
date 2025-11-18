function Get-OrgID {
    <#
    .SYNOPSIS
        Retrieves the organization ID for a Meraki organization. If more than one organization is associated with the provided authentication token, the function will return a message indicating that multiple organizations were found.
    .DESCRIPTION
        This function retrieves the organization ID for a Meraki organization using the provided authentication token.
    .PARAMETER AuthToken
        The authentication token for the Meraki API.
    .EXAMPLE
        PS C:\> Get-OrgID -AuthToken "1234567890abcdef"
        Returns the organization ID for the Meraki organization associated with the provided authentication token.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken
    )
    $Orgs = Get-MerakiOrganizations -AuthToken $AuthToken
    If ($Orgs.count -gt 1) {
        $OrganizationID = "Multiple organizations found. Please specify an organization ID."
        Return $OrganizationID
    } else {
        $OrganizationID = $Orgs[0].id
        Return $OrganizationID
    }
}