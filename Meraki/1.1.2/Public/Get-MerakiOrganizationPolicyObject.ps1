function Get-MerakiOrganizationPolicyObject {
    <#
    .SYNOPSIS
        Retrieves a policy object for a Meraki organization.
    .DESCRIPTION
        This function retrieves a policy object for a Meraki organization specified by the
        provided organization ID and policy object ID.
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve the policy object for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .PARAMETER PolicyObjectId
        The ID of the policy object to retrieve.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationPolicyObject -AuthToken "myAuthToken" -OrgId "123456" -policyObjectId "67890"
        Returns the policy object with ID "67890" for the Meraki organization with ID "123456".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$policyObjectId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/policyObjects/$policyObjectId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
