function Get-MerakiOrganizationPiiRequests {
    <#
    .SYNOPSIS
        Retrieves all PII requests for a Meraki organization.
    .DESCRIPTION
        This function retrieves all PII requests for a Meraki organization specified by the
        provided organization ID or the ID of the first organization associated with the
        provided API authentication token.
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve PII requests for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationPiiRequests -AuthToken "myAuthToken" -OrgId "123456"
        Returns all PII requests for the Meraki organization with ID "123456".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/pii/requests" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}