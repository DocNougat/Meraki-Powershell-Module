function Get-MerakiOrganizationSAMLIDPs {
    <#
    .SYNOPSIS
    Gets a list of SAML Identity Providers (IdPs) for a Meraki organization.
    
    .DESCRIPTION
    This function retrieves a list of SAML Identity Providers (IdPs) for a Meraki organization using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER OrgId
    The ID of the organization containing the SAML IdPs. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSAMLIDPs -AuthToken "your_api_key"
    
    Retrieves a list of SAML IdPs for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSAMLIDPs -AuthToken "your_api_key" -OrgId "1234"
    
    Retrieves a list of SAML IdPs for the organization with ID "1234".
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
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/saml/idps" -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}