function Get-MerakiNetworkApplianceFirewallInboundFirewallRules {
    <#
    .SYNOPSIS
    Retrieves the inbound firewall rules for a Meraki network appliance.

    .DESCRIPTION
    This function retrieves the inbound firewall rules for a specified Meraki network appliance. The function requires the user to provide an API key, as well as the ID of the network appliance for which the inbound firewall rules should be retrieved.

    .PARAMETER AuthToken
    The Meraki Dashboard API key for the user's Meraki organization.

    .PARAMETER NetworkId
    The ID of the Meraki network appliance for which inbound firewall rules should be retrieved.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallInboundFirewallRules -AuthToken '12345' -NetworkId 'N_1234567890'

    This example retrieves the inbound firewall rules for the specified Meraki network appliance.

    .NOTES
    For more information on the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/inboundFirewallRules" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error "Failed to retrieve inbound firewall rules: $_"
    }
}