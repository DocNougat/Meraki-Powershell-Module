function Get-MerakiNetworkSmUserAccessDevices {
    <#
    .SYNOPSIS
    Retrieves the list of user access devices in the Systems Manager for a given network.

    .DESCRIPTION
    This function retrieves the list of user access devices in the Systems Manager for a given network.
    
    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    Required. The network ID.
    
    .PARAMETER perPage
    Optional. The number of devices to return per page.
    
    .PARAMETER startingAfter
    Optional. A device ID to use as a starting point for the next page of results.
    
    .PARAMETER endingBefore
    Optional. A device ID to use as an ending point for the previous page of results.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmUserAccessDevices -AuthToken "12345" -NetworkId "L_1234" -perPage 50
    
    Retrieves the first 50 user access devices in the network "L_1234".
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmUserAccessDevices -AuthToken "12345" -NetworkId "L_1234" -startingAfter "abcd"
    
    Retrieves the user access devices in the network "L_1234" starting after device ID "abcd".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/sm/userAccessDevices?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
