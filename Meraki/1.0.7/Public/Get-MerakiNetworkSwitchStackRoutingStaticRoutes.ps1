function Get-MerakiNetworkSwitchStackRoutingStaticRoutes {
    <#
    .SYNOPSIS
    Get a list of static routes for a switch stack in a Meraki network.

    .DESCRIPTION
    This function retrieves a list of static routes configured for a switch stack in a Meraki network.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER networkId
    The ID of the Meraki network.

    .PARAMETER switchStackId
    The ID of the switch stack.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchStackRoutingStaticRoutes -AuthToken "12345" -networkId "N_12345" -switchStackId "12345"

    This example retrieves the list of static routes for the switch stack with ID "12345" in the Meraki network with ID "N_12345".

    .NOTES
    For more information about the Meraki Dashboard API, visit the official documentation:
    https://developer.cisco.com/meraki/api-v1/#
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$switchStackId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/stacks/$switchStackId/routing/staticRoutes" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
