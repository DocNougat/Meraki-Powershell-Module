function Get-MerakiNetworkSwitchStackRoutingStaticRoute {
    <#
    .SYNOPSIS
    Retrieves a specific static route for a switch stack in a Meraki network.
    .DESCRIPTION
    This function retrieves a specific static route for a switch stack in a Meraki network. The function requires authentication with a Meraki API key that has read access to the specified network.

    .PARAMETER AuthToken
    The Meraki API key to use for authentication.

    .PARAMETER NetworkId
    The ID of the Meraki network containing the switch stack.

    .PARAMETER SwitchStackId
    The ID of the switch stack containing the static route.

    .PARAMETER StaticRouteId
    The ID of the static route to retrieve.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStackRoutingStaticRoute -AuthToken "1234" -NetworkId "L_1234" -SwitchStackId "1234" -StaticRouteId "1234"

    Returns the static route with ID "1234" for the switch stack with ID "1234" in the Meraki network with ID "L_1234".

    .NOTES
    For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SwitchStackId,
        [parameter(Mandatory=$true)]
        [string]$StaticRouteId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/routing/staticRoutes/$StaticRouteId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}