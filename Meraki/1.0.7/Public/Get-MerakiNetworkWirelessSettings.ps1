function Get-MerakiNetworkWirelessSettings {
    <#
    .SYNOPSIS
    Retrieves the wireless settings for a specified Meraki network.
    .DESCRIPTION
    This function retrieves the wireless settings for a specified Meraki network using the Meraki Dashboard API.
    .PARAMETER AuthToken
    The Meraki API token for the account.
    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the wireless settings.
    .EXAMPLE
    PS> Get-MerakiNetworkWirelessSettings -AuthToken "1234" -networkId "abcd"
    Retrieves the wireless settings for network "abcd" using the Meraki API token "1234".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/settings" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
