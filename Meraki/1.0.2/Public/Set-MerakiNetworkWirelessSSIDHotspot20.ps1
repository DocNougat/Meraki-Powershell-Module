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
$HotspotConfig = '{
    "enabled": true,
    "operator": {
        "name": "Meraki Product Management"
    },
    "venue": {
        "name": "SF Branch",
        "type": "Unspecified Assembly"
    },
    "networkAccessType": "Private network",
    "domains": [
        "meraki.local",
        "domain2.com"
    ],
    "roamConsortOis": [ "ABC123", "456EFG" ],
    "mccMncs": [
        {
            "mcc": "123",
            "mnc": "456"
        },
        {
            "mcc": "563",
            "mnc": "232"
        }
    ],
    "naiRealms": [
        {
            "format": "1",
            "name": "Realm 1",
            "methods": [
                {
                    "id": "1",
                    "authenticationTypes": {
                        "nonEapInnerAuthentication": [ "MSCHAP" ],
                        "eapInnerAuthentication": [
                            "EAP-TTLS with MSCHAPv2"
                        ],
                        "credentials": [],
                        "tunneledEapMethodCredentials": []
                    }
                }
            ]
        }
    ]
}'
$HotspotConfig = $HotspotConfig | ConvertTo-Json -Compress
Set-MerakiNetworkWirelessSSIDHotspot20 -AuthToken "1234" -NetworkId "5678" -SSIDNumber "1" -HotspotConfig $HotspotConfig

This example sets the Hotspot 2.0 configuration for SSID 1 in the Meraki wireless network with ID 5678 using the specified Hotspot 2.0 configuration and the Meraki Dashboard API key "1234".

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
        
        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}