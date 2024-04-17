function Get-MerakiNetworkSmTargetGroup {
    <#
    .SYNOPSIS
    Retrieves a target group for a given network.

    .DESCRIPTION
    This function retrieves a target group for a given network.
    
    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    Required. The network ID.
    
    .PARAMETER targetGroupId
    Required. The ID of the target group to retrieve.
    
    .PARAMETER withDetails
    Optional. Whether to include details for the target group. Defaults to true.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmTargetGroup -AuthToken "12345" -NetworkId "L_1234" -targetGroupId "12345" -withDetails $false
    
    Retrieves the target group with ID "12345" for the network "L_1234" without details.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$targetGroupId,
        [parameter(Mandatory=$false)]
        [bool]$withDetails = $true
    )
    try{
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "Content-Type" = "application/json"
        }
        $queryParams = @{
            'withDetails' = $withDetails
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/sm/targetGroups/$targetGroupId?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
