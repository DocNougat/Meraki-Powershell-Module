function Get-MerakiNetworkCellularGatewayUplink {
    <#
    .SYNOPSIS
    Retrieves the uplink information for a Meraki cellular gateway network.

    .DESCRIPTION
    This function retrieves the uplink information for a Meraki cellular gateway network, including the current signal strength and whether the device is connected to the Meraki cloud.

    .PARAMETER AuthToken
    The Meraki Dashboard API token to use for authentication.

    .PARAMETER NetworkId
    The ID of the Meraki cellular gateway network.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkCellularGatewayUplink -AuthToken "1234" -NetworkId "N_1234"

    This example retrieves the uplink information for the Meraki cellular gateway network with ID "N_1234", using the Meraki Dashboard API token "1234" for authentication.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/uplink" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
