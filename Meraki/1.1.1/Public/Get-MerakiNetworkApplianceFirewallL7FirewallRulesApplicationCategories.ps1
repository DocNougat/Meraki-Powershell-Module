function Get-MerakiNetworkApplianceFirewallL7FirewallRulesApplicationCategories {
    <#
    .SYNOPSIS
    Gets a list of application categories for L7 firewall rules on a Meraki network's appliance.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve a list of application categories for L7 firewall rules on a Meraki network's appliance.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose appliance firewall L7 firewall rules application categories are being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceFirewallL7FirewallRulesApplicationCategories -AuthToken '1234' -NetworkId '5678'
    Retrieves a list of application categories for L7 firewall rules on the Meraki network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage='The Meraki Dashboard API key.')]
        [string]$AuthToken,

        [Parameter(Mandatory=$true, HelpMessage='The ID of the Meraki network whose appliance firewall L7 firewall rules application categories are being retrieved.')]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/l7FirewallRules/applicationCategories" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
