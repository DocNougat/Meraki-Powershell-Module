function Get-MerakiNetworkApplianceFirewallOneToManyNatRules {
    <#
    .SYNOPSIS
    Gets a list of one-to-many NAT rules for a Meraki network's appliance firewall.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve a list of one-to-many NAT rules for a Meraki network's appliance firewall.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose appliance firewall one-to-many NAT rules are being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceFirewallOneToManyNatRules -AuthToken '1234' -NetworkId '5678'
    Retrieves a list of one-to-many NAT rules for the Meraki network with ID '5678' using the API key '1234'.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/oneToManyNatRules" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}