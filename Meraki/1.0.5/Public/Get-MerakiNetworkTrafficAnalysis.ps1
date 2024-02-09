function Get-MerakiNetworkTrafficAnalysis {
    <#
    .SYNOPSIS
    Retrieves the traffic analysis settings for a Meraki network.

    .DESCRIPTION
    This function retrieves the traffic analysis settings for a Meraki network. The traffic analysis settings include
    the current status of traffic analysis, as well as any preferences that have been configured for the network's
    traffic analysis.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the Meraki network to retrieve traffic analysis settings for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkTrafficAnalysis -AuthToken '1234' -NetworkId 'abcd'
    Retrieves the traffic analysis settings for the Meraki network with ID 'abcd'.

    .NOTES
    For more information about the Meraki Dashboard API and the available endpoints, please visit
    https://developer.cisco.com/meraki/api/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/trafficAnalysis" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
