function Get-MerakiNetworkSwitchStp {
    <#
    .SYNOPSIS
    Gets the spanning tree protocol (STP) configuration for a network's switches.

    .DESCRIPTION
    The Get-MerakiNetworkSwitchStp function retrieves the STP configuration for all switches in a network.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network containing the switches.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStp -AuthToken "1234" -NetworkId "L_1234"

    This command retrieves the STP configuration for all switches in the network with ID "L_1234".

    .NOTES
    For more information on the Meraki Dashboard API, visit:
    https://developer.cisco.com/meraki/api-v1/
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/stp" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error $_
    }
}
