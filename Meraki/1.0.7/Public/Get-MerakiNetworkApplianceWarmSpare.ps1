function Get-MerakiNetworkApplianceWarmSpare {
    <#
    .SYNOPSIS
    Retrieve the warm spare configuration for a network.

    .DESCRIPTION
    Use this function to retrieve the warm spare configuration for a network in the Meraki dashboard.

    .PARAMETER AuthToken
    The authorization token for the Meraki dashboard.

    .PARAMETER NetworkId
    The ID of the network for which you want to retrieve the warm spare configuration.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceWarmSpare -AuthToken "1234" -NetworkId "abcd"

    This example retrieves the warm spare configuration for the network with ID "abcd" using the specified authorization token.

    .NOTES
    For more information, see the Meraki Dashboard API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-warm-spare
    #>
    param (
        [parameter(Mandatory=$true, HelpMessage="The authorization token for the Meraki dashboard.")]
        [string]$AuthToken,
        [parameter(Mandatory=$true, HelpMessage="The ID of the network for which you want to retrieve the warm spare configuration.")]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/warmSpare" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
