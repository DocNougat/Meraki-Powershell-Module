function Get-MerakiOrganizationPolicyObjectsGroup {
    <#
    .SYNOPSIS
    Gets a Meraki policy objects group from an organization.
    
    .DESCRIPTION
    This function retrieves a Meraki policy objects group from an organization using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER policyObjectGroupId
    The ID of the policy objects group to retrieve.
    
    .PARAMETER OrgId
    The ID of the organization containing the policy objects group. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationPolicyObjectsGroup -AuthToken "your_api_key" -policyObjectGroupId "1234"
    
    Retrieves the Meraki policy objects group with ID "1234" from the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationPolicyObjectsGroup -AuthToken "your_api_key" -policyObjectGroupId "5678" -OrgId "9999"
    
    Retrieves the Meraki policy objects group with ID "5678" from the organization with ID "9999".

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$policyObjectGroupId,
        [parameter(Mandatory=$False)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/policyObjects/groups/$policyObjectGroupId" -Header $header
            return $response
        } catch {
            Write-Error $_
        }
    }
}
