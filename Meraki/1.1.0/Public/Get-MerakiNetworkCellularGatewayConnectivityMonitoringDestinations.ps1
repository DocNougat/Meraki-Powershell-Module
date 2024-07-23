function Get-MerakiNetworkCellularGatewayConnectivityMonitoringDestinations {
    <#
    .SYNOPSIS
    Retrieves the list of connectivity monitoring destinations for a cellular gateway network.

    .DESCRIPTION
    This function retrieves the list of connectivity monitoring destinations for a cellular gateway network in the Meraki dashboard.

    .PARAMETER AuthToken
    Required. The Meraki dashboard API key.

    .PARAMETER NetworkId
    Required. The ID of the network to which the cellular gateway belongs.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkCellularGatewayConnectivityMonitoringDestinations -AuthToken '1234' -NetworkId 'N_1234567890abcdef'

    Retrieves the list of connectivity monitoring destinations for the network with ID 'N_1234567890abcdef'.

    .NOTES
    For more information about connectivity monitoring in Meraki cellular gateways, see https://documentation.meraki.com/MX-Z/Monitoring_and_Reporting/Cellular_Gateway_Connectivity_Monitoring.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/connectivityMonitoringDestinations" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
