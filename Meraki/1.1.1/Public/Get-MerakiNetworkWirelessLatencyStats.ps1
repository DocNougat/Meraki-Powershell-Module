function Get-MerakiNetworkWirelessLatencyStats {
    <#
    .SYNOPSIS
    Get latency statistics for wireless clients in a Meraki network.
    
    .DESCRIPTION
    This function retrieves latency statistics for wireless clients in a Meraki network.
    
    .PARAMETER AuthToken
    The Meraki API token for the dashboard account.
    
    .PARAMETER networkId
    The ID of the network to retrieve data for.
    
    .PARAMETER t0
    The beginning of the time range for the data. Must be in ISO 8601 format.
    
    .PARAMETER t1
    The end of the time range for the data. Must be in ISO 8601 format.
    
    .PARAMETER timespan
    The timespan for which the data should be fetched, in seconds. If both timespan and t0/t1 parameters are included, the timespan parameter takes precedence.
    
    .PARAMETER band
    The frequency band of the wireless network. Must be one of "2.4GHz" or "5GHz".
    
    .PARAMETER ssid
    The ID of the SSID to retrieve data for.
    
    .PARAMETER vlan
    The VLAN ID to retrieve data for.
    
    .PARAMETER apTag
    The tag of the access point to retrieve data for.
    
    .PARAMETER fields
    A comma-separated list of fields to include in the response. If not specified, all fields will be included.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessLatencyStats -AuthToken "1234" -networkId "abcd" -timespan 86400 -band "5GHz"
    
    This example retrieves the latency statistics for all clients connected to the 5GHz band in the Meraki network with ID "abcd" over the past 24 hours.
    
    .NOTES
    For more information on the Meraki API and available parameters, see the Meraki Dashboard API documentation at https://developer.cisco.com/meraki/api/.
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
        [string]$band = $null,
        [parameter(Mandatory=$false)]
        [int]$ssid = $null,
        [parameter(Mandatory=$false)]
        [int]$vlan = $null,
        [parameter(Mandatory=$false)]
        [string]$apTag = $null,
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
    
        if ($band) {
                $queryParams['band'] = $band
            }
    
        if ($ssid) {
                $queryParams['ssid'] = $ssid
            }
    
        if ($vlan) {
                $queryParams['vlan'] = $vlan
            }
    
        if ($apTag) {
                $queryParams['apTag'] = $apTag
            }
    
        if ($fields) {
                $queryParams['fields'] = $fields
            }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/latencyStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}