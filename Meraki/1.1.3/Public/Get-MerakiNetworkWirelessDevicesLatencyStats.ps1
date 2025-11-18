function Get-MerakiNetworkWirelessDevicesLatencyStats {
    <#
    .SYNOPSIS
    Retrieves latency stats for wireless devices in a Meraki network.

    .DESCRIPTION
    This function retrieves latency statistics for wireless devices in a Meraki network.
    
    .PARAMETER AuthToken
    The Meraki API authentication token.
    
    .PARAMETER networkId
    The ID of the Meraki network to retrieve data for.
    
    .PARAMETER t0
    The beginning of the timespan for which to retrieve data. This can be a datetime string or Unix timestamp.
    
    .PARAMETER t1
    The end of the timespan for which to retrieve data. This can be a datetime string or Unix timestamp.
    
    .PARAMETER timespan
    The timespan for which to retrieve data, in seconds.
    
    .PARAMETER apTag
    Filter results by access point tag.
    
    .PARAMETER band
    Filter results by frequency band.
    
    .PARAMETER ssid
    Filter results by SSID number.
    
    .PARAMETER vlan
    Filter results by VLAN number.
    
    .PARAMETER fields
    A comma-separated list of fields to return.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessDevicesLatencyStats -AuthToken "1234" -networkId "5678" -timespan 3600 -apTag "Office-AP"

    Retrieves latency stats for wireless devices in the "Office-AP" access point tag in the Meraki network with ID "5678" for the past hour.

    .NOTES
    For more information on the Meraki API and available parameters, see https://developer.cisco.com/meraki/api-v1/.
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
        [int]$vlan = $null,
        [parameter(Mandatory=$false)]
        [string]$fields = $null
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
    
        if ($fields) {
                $queryParams['fields'] = $fields
            }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/devices/latencyStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
