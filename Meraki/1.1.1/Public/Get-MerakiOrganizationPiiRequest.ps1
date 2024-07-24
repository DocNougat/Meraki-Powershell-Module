function Get-MerakiOrganizationPiiRequest {
    <#
    .SYNOPSIS
        Retrieves a specific PII request for a Meraki organization.
    .DESCRIPTION
        This function retrieves a specific PII request for a Meraki organization specified by
        the provided organization ID and request ID.
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve the PII request for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .PARAMETER RequestID
        The ID of the PII request to retrieve.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationPiiRequest -AuthToken "myAuthToken" -OrgId "123456" -RequestID "ABC123"
        Returns the PII request with ID "ABC123" for the Meraki organization with ID "123456".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$False)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$RequestID
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/pii/requests/$RequestID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}