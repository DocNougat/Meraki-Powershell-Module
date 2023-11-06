function Get-MerakiNetworkTrafficShapingApplicationCategories {
    <#
    .SYNOPSIS
    Gets a list of application categories for traffic shaping rules.

    .DESCRIPTION
    The Get-MerakiNetworkTrafficShapingApplicationCategories function retrieves a list of application categories that can be used to create traffic shaping rules in a Cisco Meraki network.

    .PARAMETER AuthToken
    The API key for the Cisco Meraki Dashboard.

    .PARAMETER NetworkId
    The ID of the network to retrieve application categories from.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkTrafficShapingApplicationCategories -AuthToken '1234' -NetworkId 'N_1234'

    This command retrieves a list of application categories for the network with ID 'N_1234'.

    .NOTES
    For more information on Cisco Meraki API, visit https://developer.cisco.com/meraki/api/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/trafficShaping/applicationCategories" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error "Failed to retrieve application categories for network '$NetworkId'. Error: $_"
    }
}
