function Get-MerakiNetworkWirelessUsageHistory {
    <#
    .SYNOPSIS
    Retrieves usage history for wireless clients, SSIDs, or access points in a Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkWirelessUsageHistory function retrieves usage history for wireless clients, SSIDs, or access points in a Meraki network using the Meraki Dashboard API. You must provide an API key and the ID of the network. You can optionally provide filters for the time range, resolution, client ID, device serial, AP tag, band, and SSID.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER networkId
    The ID of the network to retrieve usage history for.

    .PARAMETER t0
    The beginning of the time range to retrieve usage history for, in ISO 8601 format. If not provided, the entire timespan will be considered.

    .PARAMETER t1
    The end of the time range to retrieve usage history for, in ISO 8601 format. If not provided, the current time will be used.

    .PARAMETER timespan
    The length of the time range to retrieve usage history for, in seconds. If provided, t0 and t1 will be ignored.

    .PARAMETER resolution
    The time resolution for the returned data, in seconds.

    .PARAMETER AutoResolution
    Specifies whether or not to automatically select the best time resolution based on the provided timespan.

    .PARAMETER clientId
    The ID of the client to retrieve usage history for.

    .PARAMETER deviceSerial
    The serial number of the device to retrieve usage history for.

    .PARAMETER apTag
    The tag of the access point to retrieve usage history for.

    .PARAMETER band
    The band to retrieve usage history for. Can be "2.4" or "5".

    .PARAMETER ssid
    The number of the SSID to retrieve usage history for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessUsageHistory -AuthToken "your_api_key" -networkId "your_network_id" -t0 "2022-01-01T00:00:00Z" -t1 "2022-02-01T00:00:00Z" -resolution 3600 -clientId "your_client_id"

    Retrieves the usage history for the specified client in the specified time range with a resolution of 1 hour.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
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
        [int]$resolution = $null,
        [parameter(Mandatory=$false)]
        [bool]$AutoResolution = $true,
        [parameter(Mandatory=$false)]
        [string]$clientId = $null,
        [parameter(Mandatory=$false)]
        [string]$DeviceSerial = $null,
        [parameter(Mandatory=$false)]
        [string]$apTag = $null,
        [parameter(Mandatory=$false)]
        [string]$band = $null,
        [parameter(Mandatory=$false)]
        [int]$ssid = $null
    )
    try {
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
        if ($resolution) {
                $queryParams['resolution'] = $resolution
            }    
        if ($AutoResolution) {
                $queryParams['AutoResolution'] = $AutoResolution
            }    
        if ($clientId) {
                $queryParams['clientId'] = $clientId
            }    
        if ($DeviceSerial) {
                $queryParams['deviceSerial'] = $DeviceSerial
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
        $queryString = New-MerakiQueryString -queryParams $queryParams
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/usageHistory?$queryString"
        $URI = [uri]::EscapeUriString($URL)
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}