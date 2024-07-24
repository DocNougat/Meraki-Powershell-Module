function Get-MerakiNetworkSwitchStormControl {
    <#
    .SYNOPSIS
    Retrieves the storm control configuration for a network switch.

    .DESCRIPTION
    The Get-MerakiNetworkSwitchStormControl function retrieves the storm control configuration for a network switch.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER networkId
    The network ID of the target Meraki network.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStormControl -AuthToken "1234" -networkId "abcd"

    Retrieves the storm control configuration for the network "abcd" using the API token "1234".
    #>

    [CmdletBinding()]
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/stormControl" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
