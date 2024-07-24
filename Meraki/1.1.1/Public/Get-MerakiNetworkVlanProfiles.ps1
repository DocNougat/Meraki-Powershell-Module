function Get-MerakiNetworkVlanProfiles {
<#
.SYNOPSIS
Retrieves the VLAN profiles for a specific Meraki network.

.DESCRIPTION
The Get-MerakiNetworkVlanProfiles function retrieves the VLAN profiles for a specific Meraki network using the Meraki Dashboard API. It requires an authentication token and the network ID as input parameters.

.PARAMETER AuthToken
The authentication token for accessing the Meraki Dashboard API.

.PARAMETER NetworkId
The ID of the Meraki network for which to retrieve the VLAN profiles.

.EXAMPLE
$authToken = "your_auth_token"
$networkId = "your_network_id"
Get-MerakiNetworkVlanProfiles -AuthToken $authToken -NetworkId $networkId

This example retrieves the VLAN profiles for the specified Meraki network using the provided authentication token and network ID.

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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/vlanProfiles" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
