function Get-MerakiNetworkWirelessBilling {
    <#
.SYNOPSIS
Retrieves wireless billing information for a given Meraki network.

.DESCRIPTION
This function retrieves wireless billing information for a given Meraki network using the Meraki Dashboard API.

.PARAMETER AuthToken
The API token generated in the Meraki Dashboard.

.PARAMETER networkId
The ID of the Meraki network.

.EXAMPLE
PS C:> Get-MerakiNetworkWirelessBilling -AuthToken '12345' -networkId 'N_1234567890'

This command retrieves the wireless billing information for the Meraki network with the ID 'N_1234567890' using the API token '12345'.

.INPUTS
None.

.OUTPUTS
The function returns a collection of wireless billing objects.

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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/billing" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}    