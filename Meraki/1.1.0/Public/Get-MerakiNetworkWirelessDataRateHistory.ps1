function Get-MerakiNetworkWirelessDataRateHistory {
    <#
    .SYNOPSIS
    Retrieves the data rate history for clients, APs, or SSIDs in a Meraki wireless network.

    .DESCRIPTION
    The Get-MerakiNetworkWirelessDataRateHistory function retrieves the data rate history for clients, APs, or SSIDs in a Meraki wireless network, optionally filtered by time range, resolution, client ID, device serial, AP tag, band, and SSID.

    .PARAMETER AuthToken
    The Meraki API token to use for authentication.

    .PARAMETER NetworkId
    The Meraki network ID to retrieve the data rate history from.

    .PARAMETER T0
    The beginning of the time range for which to retrieve the data rate history, in ISO 8601 format (e.g. "2022-01-01T00:00:00Z").

    .PARAMETER T1
    The end of the time range for which to retrieve the data rate history, in ISO 8601 format (e.g. "2022-01-02T00:00:00Z").

    .PARAMETER TimeSpan
    The time span for which to retrieve the data rate history, in seconds.

    .PARAMETER Resolution
    The time resolution for the data rate history, in seconds.

    .PARAMETER AutoResolution
    Specifies whether to automatically adjust the time resolution based on the time range.

    .PARAMETER ClientId
    The client ID to retrieve the data rate history for.

    .PARAMETER DeviceSerial
    The device serial to retrieve the data rate history for.

    .PARAMETER ApTag
    The AP tag to retrieve the data rate history for.

    .PARAMETER Band
    The frequency band to retrieve the data rate history for ("2.4" or "5").

    .PARAMETER Ssid
    The SSID number to retrieve the data rate history for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessDataRateHistory -AuthToken "1234" -NetworkId "5678"

    Retrieves the data rate history for all clients, APs, and SSIDs in the Meraki network with ID "5678", using the API token "1234".

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessDataRateHistory -AuthToken "1234" -NetworkId "5678" -T0 "2022-01-01T00:00:00Z" -T1 "2022-01-02T00:00:00Z" -Band "5"

    Retrieves the data rate history for all clients and APs in the Meraki network with ID "5678", on the 5 GHz band, between January 1st, 2022 and January 2nd, 2022, using the API token "1234".

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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/dataRateHistory?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}