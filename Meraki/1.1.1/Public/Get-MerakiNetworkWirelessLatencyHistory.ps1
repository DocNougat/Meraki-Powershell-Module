function Get-MerakiNetworkWirelessLatencyHistory {
    <#
.SYNOPSIS
   Gets the latency history for wireless clients and devices in a Meraki network.
.DESCRIPTION
   This function retrieves the latency history for wireless clients and devices in a Meraki network, including latency percentiles (median, 90th and 99th percentile) and the number of samples used to compute each percentile.
.PARAMETER AuthToken
   The Meraki API token.
.PARAMETER networkId
   The network ID for which to retrieve the data.
.PARAMETER t0
   The beginning of the time range (in UTC) for which to retrieve the data. This can be a Unix timestamp or an ISO 8601 string.
.PARAMETER t1
   The end of the time range (in UTC) for which to retrieve the data. This can be a Unix timestamp or an ISO 8601 string.
.PARAMETER timespan
   The timespan for which to retrieve the data. This parameter takes precedence over t0 and t1 if specified. The timespan is an integer representing a duration in seconds.
.PARAMETER resolution
   The time resolution in seconds for the returned data. The minimum resolution is 60 seconds. The maximum resolution is 3600 seconds.
.PARAMETER AutoResolution
   If set to $true, the API will automatically determine the best resolution based on the requested time range. If set to $false, the resolution parameter will be used.
.PARAMETER clientId
   The client ID for which to retrieve the data.
.PARAMETER deviceSerial
   The device serial number for which to retrieve the data.
.PARAMETER apTag
   The access point tag for which to retrieve the data.
.PARAMETER band
   The frequency band for which to retrieve the data. Valid values are "2.4G" and "5G".
.PARAMETER ssid
   The SSID for which to retrieve the data.
.PARAMETER accessCategory
   The access category for which to retrieve the data. Valid values are "background", "bestEffort", "video", and "voice".
.EXAMPLE
   PS C:\> Get-MerakiNetworkWirelessLatencyHistory -AuthToken "1234" -networkId "5678" -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-01T01:00:00Z" -band "5G" -ssid 1
   Retrieves the latency history for the 5G band and SSID 1 in the specified time range.
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
        [int]$ssid = $null,
        [parameter(Mandatory=$false)]
        [string]$accessCategory = $null
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
    
        if ($accessCategory) {
                $queryParams['accessCategory'] = $accessCategory
            }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/latencyHistory?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}