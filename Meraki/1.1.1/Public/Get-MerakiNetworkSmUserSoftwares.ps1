function Get-MerakiNetworkSmUserSoftwares {
    <#
    .SYNOPSIS
    Retrieves the list of software installed on a Systems Manager user's device in a given network.
    
    .DESCRIPTION
    This function retrieves the list of software installed on a Systems Manager user's device in a given network.
    
    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    Required. The network ID.
    
    .PARAMETER UserId
    Required. The user ID.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmUserSoftwares -AuthToken "12345" -NetworkId "L_1234" -UserId "12345"
    
    Retrieves the list of software installed on the device associated with the user ID "12345" in the network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$userId
    )

    try{
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/users/$userId/softwares" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
