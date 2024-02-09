function Get-MerakiNetworkApplianceFirewallInboundCellularFirewallRules {
    <#
    .SYNOPSIS
    Retrieves the inbound cellular firewall rules for a given network's appliance.
    
    .DESCRIPTION
    This function retrieves the inbound cellular firewall rules for a given network's appliance. It requires authentication token and network ID as mandatory parameters.
    
    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki dashboard.
    
    .PARAMETER NetworkId
    Specifies the ID of the network whose inbound cellular firewall rules need to be retrieved.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallInboundCellularFirewallRules -AuthToken '12345' -NetworkId 'N_12345678'
    
    This example retrieves the inbound cellular firewall rules for the network with ID 'N_12345678' using the authentication token '12345'.
    
    .NOTES
    For more information on the Meraki API and the endpoints available, see https://developer.cisco.com/meraki/api-v1/.
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }
    
    $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/inboundCellularFirewallRules"
    
    try {
        $response = Invoke-RestMethod -Method Get -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}