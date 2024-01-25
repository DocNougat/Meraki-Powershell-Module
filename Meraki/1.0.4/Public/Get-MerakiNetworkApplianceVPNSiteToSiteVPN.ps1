function Get-MerakiNetworkApplianceVPNSiteToSiteVPN {
    <#
    .SYNOPSIS
    Retrieve the site-to-site VPN settings for a Meraki network appliance.

    .DESCRIPTION
    This function retrieves the site-to-site VPN settings for a specified Meraki network appliance.

    .PARAMETER AuthToken
    The Meraki API token to use for authentication.

    .PARAMETER NetworkId
    The ID of the Meraki network.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceVPNSiteToSiteVPN -AuthToken '12345' -NetworkId 'N_1234567890'

    This example retrieves the site-to-site VPN settings for the specified Meraki network.

    .NOTES
    For more information on the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vpn/siteToSiteVPN" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error $_
    }
}