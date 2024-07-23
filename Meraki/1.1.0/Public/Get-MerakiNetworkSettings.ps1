function Get-MerakiNetworkSettings {
    <#
    .SYNOPSIS
    Retrieves the settings for a specific network.

    .DESCRIPTION
    This function retrieves the settings for a specific network in the Meraki dashboard using the Meraki REST API.

    .PARAMETER AuthToken
    The Meraki API token to use for authentication.

    .PARAMETER NetworkId
    The ID of the network to retrieve the settings for.

    .EXAMPLE
    Get-MerakiNetworkSettings -AuthToken "12345" -NetworkId "N_12345"

    Retrieves the settings for the network with ID "N_12345" using the Meraki API token "12345".

    .NOTES
    For more information about the Meraki REST API, see https://developer.cisco.com/meraki/api-v1/.
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/settings" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
