function Get-MerakiOrganizationLicensesOverview {
    <#
    .SYNOPSIS
        Retrieves an overview of all licenses in a Meraki organization.
    .DESCRIPTION
        This function retrieves an overview of all licenses in a Meraki organization
        specified by the provided organization ID or the ID of the first organization
        associated with the provided API authentication token.
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve license information for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationLicensesOverview -AuthToken "myAuthToken" -OrgId "123456"
        Returns an overview of all licenses in the Meraki organization with ID "123456".
    #>
    [CmdletBinding()]
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/licenses/overview" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}
