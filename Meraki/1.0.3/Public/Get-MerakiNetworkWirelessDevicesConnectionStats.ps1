function Get-MerakiNetworkWirelessDevicesConnectionStats {
    <#
.SYNOPSIS
Retrieves wireless device connection stats for a Meraki network.

.DESCRIPTION
Retrieves wireless device connection stats for a Meraki network, including the number of devices
connected, the number of clients per device, and the average latency per device.

.PARAMETER AuthToken
The Meraki API token.

.PARAMETER networkId
The Meraki network ID.

.PARAMETER t0
The beginning of the time range for the data. Defaults to null.

.PARAMETER t1
The end of the time range for the data. Defaults to null.

.PARAMETER timespan
The timespan for which the data will be fetched, in seconds. Defaults to null.

.PARAMETER apTag
The tag of the AP to filter by. Defaults to null.

.PARAMETER band
The band to filter by. Can be "2.4" or "5". Defaults to null.

.PARAMETER ssid
The SSID to filter by. Defaults to null.

.PARAMETER vlan
The VLAN to filter by. Defaults to null.

.EXAMPLE
Get-MerakiNetworkWirelessDevicesConnectionStats -AuthToken $token -networkId $networkId

This example retrieves wireless device connection stats for a Meraki network.

.NOTES
For more information on using this function, see the Meraki API documentation:
https://developer.cisco.com/meraki/api-v1/#!get-network-wireless-devices-connection-stats
#>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [string]$apTag = $null,
        [parameter(Mandatory=$false)]
        [string]$band = $null,
        [parameter(Mandatory=$false)]
        [int]$ssid = $null,
        [parameter(Mandatory=$false)]
        [int]$vlan = $null
    )
    try{
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($timespan) {
            $queryParams['timespan'] = $timespan
        } else {
            if ($t0) {
                $queryParams['t0'] = $t0
            }
            if ($t1) {
                $queryParams['t1'] = $t1
            }
        }
    
        if ($apTag) {
                $queryParams['apTag'] = $apTag
            }
    
        if ($band) {
                $queryParams['band'] = $band
            }
    
        if ($ssid) {
                $queryParams['ssid'] = $ssid
            }
    
        if ($vlan) {
                $queryParams['vlan'] = $vlan
            }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/devices/connectionStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error $_
    }
}