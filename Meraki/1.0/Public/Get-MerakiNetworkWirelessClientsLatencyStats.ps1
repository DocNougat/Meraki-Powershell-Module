function Get-MerakiNetworkWirelessClientsLatencyStats {
    <#
    .SYNOPSIS
    Retrieves the latency statistics for wireless clients in a Meraki network.
    .DESCRIPTION
    This function retrieves the latency statistics for wireless clients in a Meraki network using the Meraki REST API.
    .PARAMETER AuthToken
    The API token used to authenticate the request. This token can be generated in the Meraki Dashboard under Organization > Settings > Dashboard API access.
    .PARAMETER networkId
    The ID of the network containing the clients to retrieve latency statistics for.
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
    A comma-separated list of fields to return in the response. Valid values are 'clientId', 'ssid', 'vlan', 'apMac', 'usage', 'latency', and 'lostPackets'.
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessClientsLatencyStats -AuthToken $token -networkId $networkId -timespan 3600
    Retrieves the latency statistics for all wireless clients in the specified network for the past hour.
    .INPUTS
    None. You cannot pipe objects to this function.
    .OUTPUTS
    The function returns an array of objects containing the following properties:
    - clientId: the ID of the client.
    - ssid: the SSID the client is connected to.
    - vlan: the VLAN the client is on.
    - apMac: the MAC address of the access point the client is connected to.
    - usage: the amount of data used by the client, in bytes.
    - latency: the average latency experienced by the client, in milliseconds.
    - lostPackets: the percentage of packets lost by the client's connection.
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/clients/latencyStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}
