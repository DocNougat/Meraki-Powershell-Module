function Get-MerakiNetworkPrefixesDelegatedStatic {
    <#
    .SYNOPSIS
    Retrieves a static delegated prefix from a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkPrefixesDelegatedStatic function retrieves a static delegated prefix from a specified Meraki network using the Meraki API. You must provide an API authentication token, the network ID, and the ID of the static delegated prefix as parameters.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve the static delegated prefix from.

    .PARAMETER staticDelegatedPrefixId
    The ID of the static delegated prefix to retrieve.

    .EXAMPLE
    Get-MerakiNetworkPrefixesDelegatedStatic -AuthToken '12345' -NetworkId 'L_123456789' -staticDelegatedPrefixId '12345'

    This example retrieves the static delegated prefix with ID '12345' from the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$staticDelegatedPrefixId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/prefixes/delegated/statics/$staticDelegatedPrefixId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
