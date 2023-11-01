function Get-MerakiNetworkSmUsers {
    <#
    .SYNOPSIS
    Retrieves a list of Systems Manager users in a network.

    .DESCRIPTION
    This function retrieves a list of Systems Manager users in a network.

    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.

    .PARAMETER NetworkId
    Required. The network ID.

    .PARAMETER ids
    Optional. An array of user IDs to filter the results.

    .PARAMETER usernames
    Optional. An array of usernames to filter the results.

    .PARAMETER emails
    Optional. An array of email addresses to filter the results.

    .PARAMETER scope
    Optional. An array of configuration profile IDs or tag IDs to filter the results.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmUsers -AuthToken "12345" -NetworkId "L_1234" -ids "12345","67890"

    Retrieves the Systems Manager users with IDs "12345" and "67890" in the network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [array]$ids = $null,
        [parameter(Mandatory=$false)]
        [array]$usernames = $null,
        [parameter(Mandatory=$false)]
        [array]$emails = $null,
        [parameter(Mandatory=$false)]
        [array]$scope = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "Content-Type" = "application/json"
        }
        $queryParams = @{}
    
        if ($ids) {
            $queryParams['ids[]'] = $ids
        }
        if ($usernames) {
            $queryParams['usernames[]'] = $usernames
        }
        if ($emails) {
            $queryParams['emails[]'] = $emails
        }
        if ($scope) {
            $queryParams['scope[]'] = $scope
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/sm/users?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}
