function Get-MerakiNetworkEventsEventTypes {
    <#
    .SYNOPSIS
        Retrieves event types for a specific Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER NetworkId
        The ID of the Meraki network.

    .EXAMPLE
        Get-MerakiNetworkEventsEventTypes -AuthToken "YOUR_API_KEY" -NetworkId "YOUR_NETWORK_ID"

        Retrieves event types for the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/events/eventTypes" -Header $header
        return $response
    } catch {
        Write-Error "An error occurred while retrieving event types for network $NetworkId. Error message: $_"
    }
}
