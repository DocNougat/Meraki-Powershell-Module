function Get-MerakiNetworkWirelessClientsConnectionStats {
    <#
    .SYNOPSIS
    Retrieves the connection statistics for wireless clients in a Meraki network.
    .DESCRIPTION
    This function retrieves the connection statistics for wireless clients in a Meraki network using the Meraki REST API.
    .PARAMETER AuthToken
    The API token used to authenticate the request. This token can be generated in the Meraki Dashboard under Organization > Settings > Dashboard API access.
    .PARAMETER networkId
    The ID of the network containing the clients to retrieve connection statistics for.
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
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessClientsConnectionStats -AuthToken $token -networkId $networkId -timespan 3600
    Retrieves the connection statistics for all wireless clients in the specified network for the past hour.
    .INPUTS
    None. You cannot pipe objects to this function.
    .OUTPUTS
    The function returns an array of objects containing the following properties:
    - mac: the MAC address of the client.
    - ipv4: the IPv4 address of the client.
    - ipv6: the IPv6 address of the client.
    - ssid: the SSID the client is connected to.
    - vlan: the VLAN the client is on.
    - apMac: the MAC address of the access point the client is connected to.
    - rssi: the received signal strength indicator (RSSI) of the client's connection.
    - connectionTime: the length of time the client has been connected, in seconds.
    - dnsLatency: the average DNS latency, in milliseconds.
    - phyRate: the PHY rate of the client's connection.
    - txRate: the TX rate of the client's connection.
    - rxRate: the RX rate of the client's connection.
    - usageSent: the amount of data sent by the client, in bytes.
    - usageReceived: the amount of data received by the client, in bytes.
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
        [string]$apTag = $null
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
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/clients/connectionStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}