function Get-MerakiNetworkSwitchACLs {
    <#
    .SYNOPSIS
    Returns the access control lists for a network switch.
    
    .DESCRIPTION
    The Get-MerakiNetworkSwitchACLs function retrieves the access control lists for a specified network switch.
    
    .PARAMETER AuthToken
    Meraki Dashboard API bearer token
    
    .PARAMETER NetworkId
    Network ID of the network for which to get switch access control lists
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchACLs -AuthToken "12345" -NetworkId "N_123456789"
    
    This example retrieves the access control lists for the specified network switch.
    
    .NOTES
    For more information on this endpoint, please visit:
    https://developer.cisco.com/meraki/api-v1/#!get-network-switch-access-control-lists
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$AuthToken,
        [parameter(Mandatory = $true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/switch/accessControlLists" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error $_
    }
}
