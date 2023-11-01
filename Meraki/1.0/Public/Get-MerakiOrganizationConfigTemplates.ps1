function Get-MerakiOrganizationConfigTemplates {
    <#
    .SYNOPSIS
    Retrieves all configuration templates in a Meraki organization.

    .DESCRIPTION
    The Get-MerakiOrganizationConfigTemplates function retrieves all configuration templates in a specified Meraki organization. You must provide a Meraki API key using the AuthToken parameter.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER OrgId
    The ID of the Meraki organization to retrieve configuration templates from. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationConfigTemplates -AuthToken "12345" -OrgId "67890"

    Retrieves all configuration templates in the Meraki organization with ID "67890" using the API key "12345".

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-MerakiOrganizations -AuthToken $AuthToken).id
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/configTemplates" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}
