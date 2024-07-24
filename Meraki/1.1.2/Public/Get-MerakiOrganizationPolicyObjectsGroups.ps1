function Get-MerakiOrganizationPolicyObjectsGroups {
    <#
    .SYNOPSIS
    Gets a list of Meraki policy objects groups from an organization.
    
    .DESCRIPTION
    This function retrieves a list of Meraki policy objects groups from an organization using the Meraki Dashboard API. You can optionally specify query parameters to filter the results.
    
    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
    
    .PARAMETER OrgId
    The ID of the organization containing the policy objects groups. If not specified, the ID of the first organization returned by Get-MerakiOrganizations is used.
    
    .PARAMETER perPage
    The number of items to return per page of results. If not specified, the default value of 10 is used.
    
    .PARAMETER startingAfter
    The ID of the last item in the previous page of results. Used for pagination to retrieve the next page of results.
    
    .PARAMETER endingBefore
    The ID of the first item in the previous page of results. Used for pagination to retrieve the previous page of results.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationPolicyObjectsGroups -AuthToken "your_api_key"
    
    Retrieves the first page of Meraki policy objects groups from the first organization returned by Get-MerakiOrganizations.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationPolicyObjectsGroups -AuthToken "your_api_key" -perPage 20 -startingAfter "1234"
    
    Retrieves the second page of Meraki policy objects groups (20 items per page) starting after the item with ID "1234" from the first organization returned by Get-MerakiOrganizations.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$False)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$False)]
        [int]$perPage,
        [parameter(Mandatory=$False)]
        [string]$startingAfter,
        [parameter(Mandatory=$False)]
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
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/policyObjects/groups?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
