function Get-MerakiOrganizationSAMLRole {
    <#
    .SYNOPSIS
    Gets a SAML role for a Meraki organization.
    
    .DESCRIPTION
    This function retrieves a SAML role for a Meraki organization using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER samlRoleId
    The ID of the SAML role to retrieve.
    
    .PARAMETER OrgId
    The ID of the organization containing the SAML role. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSAMLRole -AuthToken "your_api_key" -samlRoleId "1234"
    
    Retrieves the SAML role with ID "1234" for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSAMLRole -AuthToken "your_api_key" -samlRoleId "5678" -OrgId "9999"
    
    Retrieves the SAML role with ID "5678" for the organization with ID "9999".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$samlRoleId,
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
            
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/samlRoles/$samlRoleId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
        Write-Host $_
        Throw $_
    }
    }
}
