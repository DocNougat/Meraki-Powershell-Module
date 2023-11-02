function Get-MerakiOrganizationSmVppAccounts {
    <#
    .SYNOPSIS
    Gets all VPP accounts for a Meraki organization's Systems Manager.
    
    .DESCRIPTION
    This function retrieves all VPP accounts for a Meraki organization's Systems Manager using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER OrgId
    The ID of the organization containing the Systems Manager. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSmVppAccounts -AuthToken "your_api_key"
    
    Retrieves all VPP accounts for the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSmVppAccounts -AuthToken "your_api_key" -OrgId "5678"
    
    Retrieves all VPP accounts for the organization with ID "5678".
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/sm/vppAccounts" -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}