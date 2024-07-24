function Get-MerakiNetworkWirelessFailedConnections {
    <#
    .SYNOPSIS
    Gets a list of failed client connection events in a Meraki wireless network.
    
    .DESCRIPTION
    This function gets a list of failed client connection events in a Meraki wireless network, optionally filtered by time range, access point tag, band, SSID, VLAN, device serial, or client ID.
    
    .PARAMETER AuthToken
    Specifies the Meraki API token used to authenticate the request.
    
    .PARAMETER NetworkId
    Specifies the Meraki network ID for which to retrieve the failed connection events.
    
    .PARAMETER T0
    Specifies the start time (in UTC) for the time range in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ).
    
    .PARAMETER T1
    Specifies the end time (in UTC) for the time range in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ).
    
    .PARAMETER TimeSpan
    Specifies the duration of the time range in seconds (max 31 days).
    
    .PARAMETER ApTag
    Specifies the access point tag used to filter the failed connection events.
    
    .PARAMETER Band
    Specifies the wireless band used to filter the failed connection events (either "2.4G" or "5G").
    
    .PARAMETER Ssid
    Specifies the SSID used to filter the failed connection events.
    
    .PARAMETER Vlan
    Specifies the VLAN used to filter the failed connection events.
    
    .PARAMETER Serial
    Specifies the device serial used to filter the failed connection events.
    
    .PARAMETER ClientId
    Specifies the client ID used to filter the failed connection events.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessFailedConnections -AuthToken "12345" -NetworkId "67890"
    
    Gets a list of all failed client connection events in the Meraki network with ID "67890".
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessFailedConnections -AuthToken "12345" -NetworkId "67890" -T0 "2022-01-01T00:00:00Z" -T1 "2022-01-02T00:00:00Z"
    
    Gets a list of all failed client connection events in the Meraki network with ID "67890" between January 1, 2022 and January 2, 2022.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessFailedConnections -AuthToken "12345" -NetworkId "67890" -ApTag "Lobby-AP"
    
    Gets a list of all failed client connection events in the Meraki network with ID "67890" for the access point with tag "Lobby-AP".
    
    .NOTES
    Author: Microsoft
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
        [string]$serial = $null,
        [parameter(Mandatory=$false)]
        [string]$clientId = $null
    )
    Try{
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
    
        if ($serial) {
                $queryParams['serial'] = $serial
            }
    
        if ($clientId) {
                $queryParams['clientId'] = $clientId
            }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/failedConnections?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}