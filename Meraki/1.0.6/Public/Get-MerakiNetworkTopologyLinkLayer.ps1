function Get-MerakiNetworkTopologyLinkLayer {
    <#
    .SYNOPSIS
    Gets the link-layer topology for a given network.

    .DESCRIPTION
    This function retrieves the link-layer topology for a given network, as reported by Meraki devices.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The ID of the network for which to retrieve the topology.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkTopologyLinkLayer -AuthToken 'myAuthToken' -NetworkId 'myNetworkId'
    Returns the link-layer topology for the network with ID 'myNetworkId'.

    .NOTES
    For more information about the link-layer topology API endpoint, see:
    https://developer.cisco.com/meraki/api-v1/#!get-network-topology-link-layer
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$AuthToken,
        [parameter(Mandatory = $true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/topology/linkLayer" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
