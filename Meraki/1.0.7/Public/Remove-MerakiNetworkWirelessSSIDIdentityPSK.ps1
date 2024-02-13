function Remove-MerakiNetworkWirelessSSIDIdentityPSK {    
    <#
    .SYNOPSIS
    Deletes an existing Identity PSK for a specified SSID in a Meraki wireless network.

    .DESCRIPTION
    This function deletes an existing Identity PSK for a specified SSID in a Meraki wireless network using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER NetworkId
    The ID of the Meraki wireless network.

    .PARAMETER SSIDNumber
    The number of the SSID to delete the Identity PSK from.

    .PARAMETER IdentityPSKId
    The ID of the Identity PSK to delete.

    .EXAMPLE
    Remove-MerakiNetworkWirelessSSIDIdentityPSK -AuthToken "1234" -NetworkId "5678" -SSIDNumber "1" -IdentityPSKId "1284392014819"

    This example deletes the Identity PSK with ID 1284392014819 from SSID 1 in the Meraki wireless network with ID 5678 using the Meraki Dashboard API key "1234".

    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SSIDNumber,
        [parameter(Mandatory=$true)]
        [string]$IdentityPSKId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/identityPsks/$IdentityPSKId"
        
        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}