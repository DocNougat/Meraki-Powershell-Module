function New-MerakiNetworkWirelessSSIDIdentityPSK {
    <#
    .SYNOPSIS
    Creates a new Identity PSK for a specified SSID in a Meraki wireless network.

    .DESCRIPTION
    This function creates a new Identity PSK for a specified SSID in a Meraki wireless network using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER NetworkId
    The ID of the Meraki wireless network.

    .PARAMETER SSIDNumber
    The number of the SSID to create the Identity PSK for.

    .PARAMETER IdentityPSK
    The Identity PSK configuration to set for the specified SSID.

    .EXAMPLE
    $IdentityPSK = [PSCustomObject]@{
        id = "1284392014819"
        name = "Sample Identity PSK"
        passphrase = "secret"
        groupPolicyId = "101"
        expiresAt = "2018-02-11T00:00:00.090210Z"
    }
    $IdentityPSK = $IdentityPSK | ConvertTo-Json -Compress
    New-MerakiNetworkWirelessSSIDIdentityPSK -AuthToken "1234" -NetworkId "5678" -SSIDNumber "1" -IdentityPSK $IdentityPSK

    This example creates a new Identity PSK for SSID 1 in the Meraki wireless network with ID 5678 using the specified Identity PSK configuration and the Meraki Dashboard API key "1234".

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
        [string]$IdentityPSK
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $IdentityPSK

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/identityPsks"
        
        $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}