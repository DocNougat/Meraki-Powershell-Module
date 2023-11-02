function Get-MerakiNetworkWirelessBluetoothSettings {
    <#
.SYNOPSIS
Retrieves Bluetooth settings for a given Meraki network.

.DESCRIPTION
This function retrieves Bluetooth settings for a given Meraki network using the Meraki Dashboard API.

.PARAMETER AuthToken
The API token generated in the Meraki Dashboard.

.PARAMETER networkId
The ID of the Meraki network.

.EXAMPLE
PS C:> Get-MerakiNetworkWirelessBluetoothSettings -AuthToken '12345' -networkId 'N_1234567890'

This command retrieves the Bluetooth settings for the Meraki network with the ID 'N_1234567890' using the API token '12345'.

.INPUTS
None.

.OUTPUTS
The function returns a Bluetooth settings object.

.NOTES
For more information on the Meraki Dashboard API, please visit https://developer.cisco.com/meraki/api/.

#>
    [CmdletBinding()]
    param (
    [parameter(Mandatory=$true)]
    [string]$AuthToken,
    [parameter(Mandatory=$true)]
    [string]$networkId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/bluetooth/settings" -Header $header
        return $response
    }
    catch {
        Write-Error "Failed to retrieve Bluetooth settings for network '$networkId'. $_"
    }
}    