function Get-MerakiNetworkCellularGatewayDHCP {
    <#
    .SYNOPSIS
    Retrieves the DHCP configuration for a network's cellular gateways.

    .DESCRIPTION
    This function retrieves the DHCP configuration for a network's cellular gateways.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The network ID.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkCellularGatewayDHCP -AuthToken "1234" -NetworkId "N_1234"

    Retrieves the DHCP configuration for the network with ID "N_1234".

    .NOTES
    For more information, see the Meraki API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-cellular-gateway-dhcp
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/dhcp" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}