function Get-MerakiNetworkApplianceFirewallCellularFirewallRules {
    <#
    .SYNOPSIS
    Retrieves the cellular firewall rules for a Meraki network's appliance.

    .DESCRIPTION
    This function retrieves the cellular firewall rules for a Meraki network's appliance.
    To use this function, you must have valid Meraki API credentials with access to the network.

    .PARAMETER AuthToken
    The API key for the Meraki Dashboard.

    .PARAMETER NetworkId
    The ID of the Meraki network.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallCellularFirewallRules -AuthToken '1234' -NetworkId 'N_1234'

    Retrieves the cellular firewall rules for the Meraki network with ID 'N_1234'.

    .NOTES
    For more information about the Meraki Dashboard API, see the official documentation:
    https://developer.cisco.com/meraki/api-v1/
    #>
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/cellularFirewallRules" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    } 
    catch {
        Write-Debug $_
        Throw $_
    }
}
