function Get-MerakiOrganizationSNMP {
    <#
    .SYNOPSIS
    Gets the SNMP settings for a Meraki organization.
    
    .DESCRIPTION
    This function retrieves the SNMP settings for a Meraki organization using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER OrgId
    The ID of the organization for which to retrieve SNMP settings. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSNMP -AuthToken "your_api_key"
    
    Retrieves the SNMP settings for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSNMP -AuthToken "your_api_key" -OrgId "5678"
    
    Retrieves the SNMP settings for the organization with ID "5678".
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/snmp" -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}