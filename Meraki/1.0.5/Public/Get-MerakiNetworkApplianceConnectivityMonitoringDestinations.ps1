function Get-MerakiNetworkApplianceConnectivityMonitoringDestinations {
    <#
.SYNOPSIS
Gets the connectivity monitoring destinations for a Meraki network's appliances.

.DESCRIPTION
The Get-MerakiNetworkApplianceConnectivityMonitoringDestinations function gets the connectivity monitoring destinations for a Meraki network's appliances. 

.PARAMETER AuthToken
The Meraki API token.

.PARAMETER NetworkId
The ID of the Meraki network.

.EXAMPLE
PS C:\> Get-MerakiNetworkApplianceConnectivityMonitoringDestinations -AuthToken '12345' -NetworkId 'abcd'

This command gets the connectivity monitoring destinations for the Meraki network with ID 'abcd', using the Meraki API token '12345'.

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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/connectivityMonitoringDestinations" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
