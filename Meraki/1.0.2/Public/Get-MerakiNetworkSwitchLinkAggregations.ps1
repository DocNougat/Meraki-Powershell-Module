function Get-MerakiNetworkSwitchLinkAggregations {
    <#
    .SYNOPSIS
        Gets the link aggregations for a Meraki network switch.
    .DESCRIPTION
        This function retrieves the link aggregations for a Meraki network switch using the Meraki Dashboard API.
    .PARAMETER AuthToken
        The API authentication token for the Meraki Dashboard.
    .PARAMETER networkId
        The ID of the Meraki network to retrieve the link aggregations for.
    .EXAMPLE
        PS C:\> Get-MerakiNetworkSwitchLinkAggregations -AuthToken "api_token" -networkId "L_123456789"
        Returns the link aggregations for the specified Meraki network switch.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/linkAggregations" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error "Failed to retrieve link aggregations for network '$networkId'. Error: $_"
    }
}
