function Get-MerakiNetworkWirelessClientLatencyStats {
    <#
    .SYNOPSIS
    Retrieves the latency statistics for a wireless client in Meraki Dashboard.
    .DESCRIPTION
    This function retrieves the latency statistics for a wireless client in Meraki Dashboard using the Meraki REST API.
    .PARAMETER AuthToken
    The API token used to authenticate the request. This token can be generated in the Meraki Dashboard under Organization > Settings > Dashboard API access.
    .PARAMETER networkId
    The ID of the network containing the client to retrieve latency statistics for.
    .PARAMETER clientId
    The ID of the client to retrieve latency statistics for.
    .PARAMETER t0
    The beginning of the time range for the data. This parameter is ignored if timespan is provided.
    .PARAMETER t1
    The end of the time range for the data. This parameter is ignored if timespan is provided.
    .PARAMETER timespan
    The timespan of the data to retrieve, in seconds. If timespan is provided, t0 and t1 are ignored.
    .PARAMETER band
    The band (either '2.4GHz' or '5GHz') to retrieve statistics for.
    .PARAMETER ssid
    The ID of the SSID to retrieve statistics for.
    .PARAMETER vlan
    The ID of the VLAN to retrieve statistics for.
    .PARAMETER apTag
    The tag of the access point to retrieve statistics for.
    .PARAMETER fields
    A comma-separated list of fields to include in the response. Valid values are 'packetsLostPercent', 'latencyMsPercentile', 'latencyMsAvg', and 'jitterMsAvg'.
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessClientLatencyStats -AuthToken $token -networkId $networkId -clientId $clientId -timespan 3600
    Retrieves the latency statistics for the specified client for the past hour.
    .INPUTS
    None. You cannot pipe objects to this function.
    .OUTPUTS
    The function returns an object containing the following properties:
    - packetsLostPercent: the percentage of packets lost.
    - latencyMsPercentile: the latency percentile in milliseconds.
    - latencyMsAvg: the average latency in milliseconds.
    - jitterMsAvg: the average jitter in milliseconds.
    .NOTES
    This function requires the Meraki PowerShell module, which can be installed from the PowerShell Gallery using the following command:
    Install-Module -Name Meraki
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$clientId,
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/clients/$clientId/latencyStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}