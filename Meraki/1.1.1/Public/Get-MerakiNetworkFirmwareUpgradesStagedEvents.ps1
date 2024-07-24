function Get-MerakiNetworkFirmwareUpgradesStagedEvents {
    <#
    .SYNOPSIS
        Retrieves staged events for firmware upgrades for a specific Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER NetworkID
        The ID of the Meraki network.

    .EXAMPLE
        Get-MerakiNetworkFirmwareUpgradesStagedEvents -AuthToken "YOUR_API_KEY" -NetworkID "YOUR_NETWORK_ID"

        Retrieves staged events for firmware upgrades for the specified network.

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
        
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkID/firmwareUpgrades/staged/events" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
