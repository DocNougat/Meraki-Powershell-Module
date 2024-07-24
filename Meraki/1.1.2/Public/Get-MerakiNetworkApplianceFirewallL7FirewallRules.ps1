function Get-MerakiNetworkApplianceFirewallL7FirewallRules {
    <#
    .SYNOPSIS
    Gets the L7 firewall rules for a Meraki network appliance.

    .DESCRIPTION
    This function retrieves the L7 firewall rules configured for a specific Meraki network appliance.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The ID of the Meraki network associated with the appliance.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceFirewallL7FirewallRules -AuthToken $AuthToken -NetworkId $NetworkId

    Retrieves the L7 firewall rules for the specified Meraki network appliance.

    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AuthToken,
        [Parameter(Mandatory = $true)]
        [string]$NetworkId
    )

    $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/firewall/l7FirewallRules"

    $header = @{
        'X-Cisco-Meraki-API-Key' = $AuthToken
    }

    try {
        $response = Invoke-RestMethod -Method Get -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
