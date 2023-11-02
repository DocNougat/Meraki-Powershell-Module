function Get-MerakiNetworkFirmwareUpgradesStagedStages {
    <#
    .SYNOPSIS
        Retrieves the staged firmware upgrade stages for a specific Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER NetworkID
        The ID of the Meraki network.

    .EXAMPLE
        Get-MerakiNetworkFirmwareUpgradesStagedStages -AuthToken "YOUR_API_KEY" -NetworkID "YOUR_NETWORK_ID"

        Retrieves the firmware upgrade stages for the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkID
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkID/firmwareUpgrades/staged/stages" -Header $header
        return $response
    } catch {
        Write-Error "An error occurred while retrieving staged firmware upgrade stages for network $NetworkID. Error message: $_"
    }
}
