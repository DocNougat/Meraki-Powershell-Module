function Get-MerakiNetworkPiiRequest {
    <#
    .SYNOPSIS
    Retrieves Personally Identifiable Information (PII) request data for a specified Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkPiiRequest function retrieves PII request data for a specified Meraki network using the Meraki API. You must provide an API authentication token, the network ID, and the request ID as parameters.

    .PARAMETER AuthToken
    The Meraki API authentication token.

    .PARAMETER NetworkId
    The ID of the network to retrieve PII request data for.

    .PARAMETER RequestID
    The ID of the PII request to retrieve data for.

    .EXAMPLE
    Get-MerakiNetworkPiiRequest -AuthToken '12345' -NetworkId 'L_123456789' -RequestID '12345'

    This example retrieves PII request data for the Meraki network with ID 'L_123456789' and the PII request with ID '12345' using the Meraki API authentication token '12345'.

    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$RequestID
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/pii/requests/$RequestID" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
