function Get-MerakiNetworkSwitchStackRoutingInterfaceDHCP {
    <#
    .SYNOPSIS
    Get DHCP settings for a routing interface on a Meraki switch stack in a specified network.

    .DESCRIPTION
    This function retrieves the DHCP settings for a routing interface on a Meraki switch stack in a specified network using the Meraki Dashboard API. The function requires authentication with a valid Meraki API key.

    .PARAMETER AuthToken
    The Meraki API key for authentication.

    .PARAMETER networkId
    The ID of the network containing the switch stack.

    .PARAMETER switchStackId
    The ID of the switch stack containing the routing interface.

    .PARAMETER interfaceId
    The ID of the routing interface.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStackRoutingInterfaceDHCP -AuthToken "1234" -networkId "L_1234567890123456789" -switchStackId "123" -interfaceId "1"

    This example retrieves the DHCP settings for routing interface 1 on switch stack 123 in the network with ID "L_1234567890123456789", using the Meraki API key "1234".

    .NOTES
    For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.

    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$switchStackId,
        [parameter(Mandatory=$true)]
        [string]$interfaceId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/stacks/$switchStackId/routing/interfaces/$interfaceId/dhcp" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}