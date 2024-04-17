function Get-MerakiNetworkSwitchStackRoutingInterface {
    <#
    .SYNOPSIS
    Retrieves a specific routing interface for a switch stack in a Meraki network.

    .DESCRIPTION
    This function retrieves information about a specific routing interface of a switch stack in a Meraki network, 
    specified by the switch stack ID and interface ID. The information includes the interface ID, VLAN, subnet, 
    and gateway IP address. 

    .PARAMETER AuthToken
    Specifies the Meraki Dashboard API key to use for authentication.

    .PARAMETER NetworkId
    Specifies the ID of the network containing the switch stack.

    .PARAMETER SwitchStackId
    Specifies the ID of the switch stack to retrieve the routing interface for.

    .PARAMETER InterfaceId
    Specifies the ID of the routing interface to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStackRoutingInterface -AuthToken '1234' -NetworkId 'N_1234' -SwitchStackId '123' -InterfaceId '456'
    This example retrieves the routing interface with ID '456' for the switch stack with ID '123' in the Meraki network with ID 'N_1234', using the API key '1234'.

    .NOTES
    For more information, see the Meraki API documentation: https://developer.cisco.com/meraki/api-v1/#!get-network-switch-stacks-stackId-routing-interfaces-interfaceId
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,

        [parameter(Mandatory=$true)]
        [string]$NetworkId,

        [parameter(Mandatory=$true)]
        [string]$SwitchStackId,

        [parameter(Mandatory=$true)]
        [string]$InterfaceId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/routing/interfaces/$InterfaceId"
        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
