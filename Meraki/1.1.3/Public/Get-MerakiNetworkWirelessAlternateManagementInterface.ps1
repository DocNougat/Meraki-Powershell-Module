function Get-MerakiNetworkWirelessAlternateManagementInterface {
    <#
.SYNOPSIS
Retrieves the alternate management interface for a given Meraki network.

.DESCRIPTION
This function retrieves the alternate management interface for a given Meraki network using the Meraki Dashboard API.

.PARAMETER AuthToken
The API token generated in the Meraki Dashboard.

.PARAMETER networkId
The ID of the Meraki network.

.EXAMPLE
PS C:> Get-MerakiNetworkWirelessAlternateManagementInterface -AuthToken '12345' -networkId 'N_1234567890'

This command retrieves the alternate management interface for the Meraki network with the ID 'N_1234567890' using the API token '12345'.

.INPUTS
None.

.OUTPUTS
The function returns an alternate management interface object.

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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/alternateManagementInterface" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}    