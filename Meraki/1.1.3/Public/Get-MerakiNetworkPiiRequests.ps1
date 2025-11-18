function Get-MerakiNetworkPiiRequests {
    <#
    .SYNOPSIS
    Retrieves Personally Identifiable Information (PII) requests for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkPiiRequests function retrieves PII requests for a specified Meraki network using the Meraki API. You must provide an API authentication token and the network ID as parameters.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve PII requests for.

    .EXAMPLE
    Get-MerakiNetworkPiiRequests -AuthToken '12345' -NetworkId 'L_123456789'

    This example retrieves PII requests for the Meraki network with ID 'L_123456789' using the Meraki API authentication token '12345'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/pii/requests" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
