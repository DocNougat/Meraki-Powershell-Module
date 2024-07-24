function Get-MerakiNetworkSwitchDHCPServerPolicy {
    <#
    .SYNOPSIS
        Gets the DHCP server policy configuration for a Meraki network switch.
    .DESCRIPTION
        This function retrieves the DHCP server policy configuration for a Meraki network switch using the Meraki Dashboard API.
    .PARAMETER AuthToken
        The API authentication token for the Meraki Dashboard.
    .PARAMETER networkId
        The ID of the Meraki network to retrieve the DHCP server policy for.
    .EXAMPLE
        PS C:\> Get-MerakiNetworkSwitchDHCPServerPolicy -AuthToken "api_token" -networkId "L_123456789"
        Returns the DHCP server policy configuration for the specified Meraki network switch.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/dhcpServerPolicy" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}