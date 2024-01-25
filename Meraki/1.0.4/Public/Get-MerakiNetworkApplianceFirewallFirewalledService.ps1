function Get-MerakiNetworkApplianceFirewallFirewalledService {
    <#
    .SYNOPSIS
    Get the details of a specific firewalled service for a network's appliance firewall.

    .DESCRIPTION
    This function retrieves the details of a specific firewalled service for a network's appliance firewall, as identified by the provided service name.

    .PARAMETER AuthToken
    The Meraki API key.

    .PARAMETER NetworkId
    The network ID.

    .PARAMETER Service
    The name of the firewalled service.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallFirewalledService -AuthToken "1234" -NetworkId "N_1234" -Service "DNS"

    This example retrieves the details of the "DNS" firewalled service for the network with ID "N_1234".

    .NOTES
    For more information on the Meraki API and its functionality, visit https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, HelpMessage="The Meraki API key.")]
        [string]$AuthToken,
        [parameter(Mandatory=$true, HelpMessage="The network ID.")]
        [string]$NetworkId,
        [parameter(Mandatory=$true, HelpMessage="The name of the firewalled service.")]
        [string]$Service
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/firewalledServices/$service" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error $_
    }
}