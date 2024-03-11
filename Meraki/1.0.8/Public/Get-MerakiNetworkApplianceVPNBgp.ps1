function Get-MerakiNetworkApplianceVPNBgp {
    <#
        .SYNOPSIS
            Retrieve the BGP settings for an MX network.

        .DESCRIPTION
            This function retrieves the BGP settings for an MX network in the Meraki Dashboard.

        .PARAMETER AuthToken
            The Meraki Dashboard API token.

        .PARAMETER NetworkId
            The network ID of the MX network.

        .EXAMPLE
            PS C:\> Get-MerakiNetworkApplianceVPNBgp -AuthToken '1234' -NetworkId 'N_12345678'

            This example retrieves the BGP settings for the MX network with the ID 'N_12345678' using the API token '1234'.

        .NOTES
            For more information about BGP settings in the Meraki Dashboard, please see:
            https://documentation.meraki.com/MX/Firewall_and_Traffic_Shaping/Configuring_BGP#Dashboard_Configuration
    #>
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/vpn/bgp" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
