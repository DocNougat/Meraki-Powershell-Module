function Get-MerakiNetworkWirelessSsidIdentityPsk {
    <#
    .SYNOPSIS
    Retrieves the identity PSK settings for a specified SSID in a Meraki network.
    .DESCRIPTION
    This function retrieves the identity PSK settings for a specified SSID in a Meraki network using the Meraki Dashboard API.
    .PARAMETER AuthToken
    The Meraki API token for the account.
    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the identity PSK settings.
    .PARAMETER SSIDNumber
    The number of the SSID for which to retrieve the identity PSK settings.
    .PARAMETER identityPskId
    The ID of the identity PSK for which to retrieve the settings.
    .EXAMPLE
    PS> Get-MerakiNetworkWirelessSsidIdentityPsk -AuthToken "1234" -networkId "abcd" -SSIDNumber 1 -identityPskId "efgh"
    Retrieves the identity PSK settings for SSID 1 in network "abcd" and identity PSK "efgh" using the Meraki API token "1234".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$SSIDNumber,
        [parameter(Mandatory=$true)]
        [string]$identityPskId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/ssids/$SSIDNumber/identityPsks/$identityPskId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
