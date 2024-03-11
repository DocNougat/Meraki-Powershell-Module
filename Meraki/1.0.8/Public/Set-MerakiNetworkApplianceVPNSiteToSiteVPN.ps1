function Set-MerakiNetworkApplianceVPNSiteToSiteVPN {
    <#
    .SYNOPSIS
    Configures site-to-site VPN settings for a Meraki network's appliance using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceVPNSiteToSiteVPN function allows you to configure site-to-site VPN settings for a specified Meraki network's appliance by providing the authentication token, network ID, and VPN configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to configure the site-to-site VPN settings.

    .PARAMETER VPNConfig
    The JSON configuration for the site-to-site VPN. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $config = [PSCustomObject]@{
        mode = "spoke"
        hubs = @(
            @{
                hubId = "N_638948197133212683"
                useDefaultRoute = $false
            },
            @{
                hubId = "N_725079540006653672"
                useDefaultRoute = $false
            },
            @{
                hubId = "L_725079540006651259"
                useDefaultRoute = $false
            }
        )
        subnets = @(
            @{
                localSubnet = "10.117.14.0/24"
                useVPN = $true
            },
            @{
                localSubnet = "10.117.100.0/24"
                useVPN = $false
            }
        )
    }

    $config = $config | ConvertTo-Json -Compress

    Set-MerakiNetworkApplianceVPNSiteToSiteVPN -AuthToken "your-api-token" -NetworkId "N_1234567890" -VPNConfig $config

    This example configures site-to-site VPN settings for the Meraki network with ID "N_1234567890" using the provided VPN configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the configuration is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$VPNConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $VPNConfig

        $url = "https://api.meraki.com/api/v1/networks/$networkId/appliance/vpn/siteToSiteVPN"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
