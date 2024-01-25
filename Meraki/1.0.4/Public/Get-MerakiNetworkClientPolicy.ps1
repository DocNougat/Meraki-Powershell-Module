<#
.SYNOPSIS
Retrieves the group policy applied to a client on a Meraki network.

.DESCRIPTION
The Get-MerakiNetworkClientPolicy function retrieves the group policy applied to a specific client on a Meraki network using the Meraki Dashboard API. The function requires a valid Meraki API token and the ID of the target network and client.

.PARAMETER AuthToken
The Meraki API token.

.PARAMETER NetworkID
The ID of the target network.

.PARAMETER ClientID
The ID of the target client.

.EXAMPLE
PS C:\> Get-MerakiNetworkClientPolicy -AuthToken "1234" -NetworkID "N_12345678" -ClientID "C_12345678"

Returns the policy applied to the specified client on the specified network.

.NOTES
For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api/.
#>
function Get-MerakiNetworkClientPolicy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AuthToken,
        [Parameter(Mandatory = $true)]
        [string]$NetworkID,
        [Parameter(Mandatory = $true)]
        [string]$ClientID
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkID/clients/$ClientID/policy" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error "Failed to retrieve client policy: $_"
    }
}