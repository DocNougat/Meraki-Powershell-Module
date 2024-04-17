function Get-MerakiNetworkWirelessSsidIdentityPsks {
    <#
        .SYNOPSIS
        Retrieve the Identity PSKs of a wireless SSID.

        .DESCRIPTION
        This function retrieves the Identity PSKs of a wireless SSID in a Meraki network.

        .PARAMETER AuthToken
        The Meraki Dashboard API token.

        .PARAMETER NetworkId
        The network ID.

        .PARAMETER Number
        The SSID number.

        .EXAMPLE
        PS C:\> Get-MerakiNetworkWirelessSsidIdentityPsks -AuthToken "1234" -NetworkId "N_1234" -Number "2"

        Retrieves the Identity PSKs of the wireless SSID number 2 in the Meraki network with ID N_1234.

        .NOTES
        For more information about Meraki Dashboard API, visit https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$Number
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$Number/identityPsks" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
