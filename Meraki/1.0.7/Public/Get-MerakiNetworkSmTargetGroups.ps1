function Get-MerakiNetworkSmTargetGroups {
    <#
    .SYNOPSIS
    Retrieves the list of target groups in the Systems Manager for a given network.

    .DESCRIPTION
    This function retrieves the list of target groups in the Systems Manager for a given network.
    
    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    Required. The network ID.
    
    .PARAMETER withDetails
    Optional. A boolean indicating whether or not to include detailed information about each target group.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmTargetGroups -AuthToken "12345" -NetworkId "L_1234" -withDetails $true
    
    Retrieves the list of target groups with detailed information for the network "L_1234".
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmTargetGroups -AuthToken "12345" -NetworkId "L_1234" -withDetails $false
    
    Retrieves the list of target groups without detailed information for the network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [bool]$withDetails = $true
    )
    
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "Content-Type" = "application/json"
        }
        
        $queryParams = @{
            "withDetails" = $withDetails
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/sm/targetGroups?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
