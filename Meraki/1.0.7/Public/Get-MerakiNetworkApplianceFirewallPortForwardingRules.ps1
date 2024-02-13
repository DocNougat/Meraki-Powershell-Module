function Get-MerakiNetworkApplianceFirewallPortForwardingRules {
    <#
    .SYNOPSIS
    Gets a list of port forwarding rules for a Meraki network's appliance firewall.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve a list of port forwarding rules for a Meraki network's appliance firewall.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose appliance firewall port forwarding rules are being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceFirewallPortForwardingRules -AuthToken '1234' -NetworkId '5678'
    Retrieves a list of port forwarding rules for the Meraki network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/portForwardingRules" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}