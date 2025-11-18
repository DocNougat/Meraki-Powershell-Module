function Get-MerakiNetworkSmProfiles {
    <#
    .SYNOPSIS
    Retrieves a list of configuration profiles in a specified network.

    .DESCRIPTION
    This function retrieves a list of configuration profiles in a specified network.

    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.

    .PARAMETER NetworkId
    Required. The network ID.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmProfiles -AuthToken "12345" -NetworkId "L_1234"

    Retrieves a list of configuration profiles for network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/sm/profiles" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    } 
    catch {
        Write-Debug $_
        Throw $_
    }
}
