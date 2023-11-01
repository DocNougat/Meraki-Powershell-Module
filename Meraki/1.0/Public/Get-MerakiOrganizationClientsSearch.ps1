function Get-MerakiOrganizationClientsSearch {
    <#
    .SYNOPSIS
    Searches for clients in a Meraki organization based on MAC address.

    .DESCRIPTION
    The Get-MerakiOrganizationClientsSearch function searches for clients in a specified Meraki organization based on MAC address. You must provide a Meraki API key using the AuthToken parameter, and the MAC address of the client to search for using the mac parameter.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER mac
    The MAC address of the client to search for.

    .PARAMETER OrgId
    The ID of the Meraki organization to search for the client in. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER perPage
    The number of search results to return per page. If not specified, the API will return a maximum of 1000 results.

    .PARAMETER startingAfter
    A token representing the client to start the search after. Only results after this client will be returned.

    .PARAMETER endingBefore
    A token representing the client to end the search before. Only results before this client will be returned.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationClientsSearch -AuthToken "12345" -mac "00:11:22:33:44:55" -OrgId "67890"

    Searches for a client with the MAC address "00:11:22:33:44:55" in the Meraki organization with ID 67890 using the API key "12345".

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$mac,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [Parameter(Mandatory=$false)]
        [string]$perPage,
        [Parameter(Mandatory=$false)]
        [string]$startingAfter,
        [Parameter(Mandatory=$false)]
        [string]$endingBefore
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $queryParams = @{}
        $queryParams['mac'] = $mac
    
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
    
        $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/clients/search?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}
