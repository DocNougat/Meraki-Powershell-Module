function Get-MerakiNetworkApplianceFirewallL3FirewallRules {
    <#
    .SYNOPSIS
    Retrieves the L3 firewall rules for a Meraki network's appliance.

    .DESCRIPTION
    The Get-MerakiNetworkApplianceFirewallL3FirewallRules function retrieves the L3 firewall rules for a specified Meraki network's appliance.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The ID of the Meraki network.

    .EXAMPLE
    Get-MerakiNetworkApplianceFirewallL3FirewallRules -AuthToken $AuthToken -NetworkId $NetworkId

    This command retrieves the L3 firewall rules for the specified Meraki network.

    .NOTES
    For more information about L3 firewall rules, see the following link:
    https://documentation.meraki.com/General_Administration/Cross-Platform_Content/Firewall_Rules

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-firewall-l3-firewall-rules

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AuthToken,
        [Parameter(Mandatory = $true)]
        [string]$NetworkId
    )

    $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/l3FirewallRules"

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
    
        $response = Invoke-RestMethod -Method Get -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}