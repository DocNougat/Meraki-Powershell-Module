function Get-MerakiOrganizationPolicyObjects {
    <#
    .SYNOPSIS
        Retrieves a list of policy objects for a Meraki organization.
    .DESCRIPTION
        This function retrieves a list of policy objects for a Meraki organization
        specified by the provided organization ID or the ID of the first organization
        associated with the provided API authentication token.
    .PARAMETER AuthToken
        The Meraki API authentication token to use for the request.
    .PARAMETER OrgId
        The ID of the Meraki organization to retrieve policy objects for.
        If not specified, the ID of the first organization associated with the provided
        authentication token will be used.
    .PARAMETER perPage
        The number of policy objects to return per page. Must be an integer between 3 and 1000.
    .PARAMETER startingAfter
        A policy object ID to use as the starting point for the page of results.
    .PARAMETER endingBefore
        A policy object ID to use as the ending point for the page of results.
    .EXAMPLE
        PS C:\> Get-MerakiOrganizationPolicyObjects -AuthToken "myAuthToken" -OrgId "123456" -perPage 50
        Returns a list of up to 50 policy objects for the Meraki organization with ID "123456".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [ValidateRange(3, 1000)]
        [int]$perPage,
        [string]$startingAfter,
        [string]$endingBefore
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $queryParams = @{}
        
            if ($perPage) {
                $queryParams['perPage'] = $perPage
            }
            if ($startingAfter) {
                $queryParams['startingAfter'] = $startingAfter
            }
            if ($endingBefore) {
                $queryParams['endingBefore'] = $endingBefore
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/policyObjects?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}