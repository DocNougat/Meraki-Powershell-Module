function Get-MerakiNetworkClientUsageHistory {
    <#
    .SYNOPSIS
        Retrieves the usage history for a specific client on a Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER networkId
        The ID of the Meraki network.

    .PARAMETER clientID
        The ID of the client whose usage history is to be retrieved. Default is null.

    .EXAMPLE
        Get-MerakiNetworkClientUsageHistory -AuthToken "YOUR_API_KEY" -networkId "YOUR_NETWORK_ID" -clientID "YOUR_CLIENT_ID"

        Retrieves the usage history for the specified client on the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId,
        [Parameter(Mandatory=$false)]
        [string]$clientID = $null
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/clients/$clientID/usageHistory" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}