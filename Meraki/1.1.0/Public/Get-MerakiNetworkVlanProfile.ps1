function Get-MerakiNetworkVlanProfile {
    <#
.SYNOPSIS
Retrieves a VLAN profile from a Meraki network.

.DESCRIPTION
The Get-MerakiNetworkVlanProfile function retrieves a VLAN profile from a Meraki network using the Meraki Dashboard API.

.PARAMETER AuthToken
The authentication token for accessing the Meraki Dashboard API.

.PARAMETER NetworkId
The ID of the Meraki network.

.PARAMETER iname
The name of the VLAN profile to retrieve.

.EXAMPLE
Get-MerakiNetworkVlanProfile -AuthToken "yourAuthToken" -NetworkId "yourNetworkId" -iname "yourVlanProfileIName"

This example retrieves the VLAN profile with the specified name from the specified Meraki network using the provided authentication token.

#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$iname
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/vlanProfiles/$iname" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
