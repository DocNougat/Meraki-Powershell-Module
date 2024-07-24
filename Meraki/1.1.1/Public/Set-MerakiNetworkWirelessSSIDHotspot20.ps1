function Set-MerakiNetworkWirelessSSIDHotspot20 {
<#
.SYNOPSIS
Sets the Hotspot 2.0 configuration for a specified SSID in a Meraki wireless network.

.DESCRIPTION
This function sets the Hotspot 2.0 configuration for a specified SSID in a Meraki wireless network using the Meraki Dashboard API.

.PARAMETER AuthToken
The Meraki Dashboard API key.

.PARAMETER NetworkId
The ID of the Meraki wireless network.

.PARAMETER SSIDNumber
The number of the SSID to set the Hotspot 2.0 configuration for.

.PARAMETER HotspotConfig
The Hotspot 2.0 configuration to set for the specified SSID.

.EXAMPLE
$HotspotConfig = [PSCustomObject]@{
    enabled = $true
    operator = @{
        name = "Meraki Product Management"
    }
    venue = @{
        name = "SF Branch"
        type = "Unspecified Assembly"
    }
    networkAccessType = "Private network"
    domains = @(
        "meraki.local",
        "domain2.com"
    )
    roamConsortOis = @(
        "ABC123",
        "456EFG"
    )
    mccMncs = @(
        @{
            mcc = "123"
            mnc = "456"
        },
        @{
            mcc = "563"
            mnc = "232"
        }
    )
    naiRealms = @(
        @{
            format = "1"
            name = "Realm 1"
            methods = @(
                @{
                    id = "1"
                    authenticationTypes = @{
                        nonEapInnerAuthentication = @("MSCHAP")
                        eapInnerAuthentication = @("EAP-TTLS with MSCHAPv2")
                        credentials = @()
                        tunneledEapMethodCredentials = @()
                    }
                }
            )
        }
    )
}

$HotspotConfig = $HotspotConfig | ConvertTo-Json -Compress
Set-MerakiNetworkWirelessSSIDHotspot20 -AuthToken "your-api-token" -NetworkId "1234" -SSIDNumber "1" -HotspotConfig $HotspotConfig

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
        [string]$HotspotConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }
        
        $body = $HotspotConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/hotspot20"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}