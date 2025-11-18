function Get-MerakiNetworkFirmwareUpgradesStagedGroup {
    <#
    .SYNOPSIS
        Retrieves a staged firmware upgrade group for a specific Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER NetworkID
        The ID of the Meraki network.

    .PARAMETER GroupID
        The ID of the firmware upgrade group.

    .EXAMPLE
        Get-MerakiNetworkFirmwareUpgradesStagedGroup -AuthToken "YOUR_API_KEY" -NetworkID "YOUR_NETWORK_ID" -GroupID "YOUR_GROUP_ID"

        Retrieves the specified firmware upgrade group for the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkID,
        [Parameter(Mandatory=$true)]
        [string]$GroupID
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkID/firmwareUpgrades/staged/Groups/$GroupID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
