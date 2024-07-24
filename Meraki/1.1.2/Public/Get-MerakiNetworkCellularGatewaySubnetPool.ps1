function Get-MerakiNetworkCellularGatewaySubnetPool {
    <#
    .SYNOPSIS
    Retrieves the subnet pool of a Meraki cellular gateway network.

    .DESCRIPTION
    The Get-MerakiNetworkCellularGatewaySubnetPool function retrieves the subnet pool of a Meraki cellular gateway network
    using the Meraki Dashboard API. The function requires an API key and network ID as input parameters.

    .PARAMETER AuthToken
    Specifies the API key for the Meraki Dashboard.

    .PARAMETER NetworkId
    Specifies the ID of the Meraki network.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkCellularGatewaySubnetPool -AuthToken '12345' -NetworkId 'L_1234567890123456789'

    This example retrieves the subnet pool of the Meraki network with ID 'L_1234567890123456789' using the API key '12345'.

    .NOTES
    For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/cellularGateway/subnetPool" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
