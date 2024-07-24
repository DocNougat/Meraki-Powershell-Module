function Get-MerakiNetworkWirelessSignalQualityHistory {
    <#
    .SYNOPSIS
    Retrieves the signal quality history for wireless clients and access points in a Meraki network.
    .DESCRIPTION
    This function retrieves the signal quality history for wireless clients and access points in a Meraki network using the Meraki Dashboard API.
    .PARAMETER AuthToken
    The Meraki API token for the account.
    .PARAMETER networkId
    The ID of the Meraki network for which to retrieve the signal quality history.
    .PARAMETER t0
    The beginning of the timespan for which to retrieve data, in ISO 8601 format. Required if t1 is specified.
    .PARAMETER t1
    The end of the timespan for which to retrieve data, in ISO 8601 format. Required if t0 is specified.
    .PARAMETER timespan
    The timespan for which to retrieve data, in seconds. Required if t0 and t1 are not specified.
    .PARAMETER resolution
    The time resolution in seconds for returned data. Default is 60 seconds.
    .PARAMETER AutoResolution
    Determines whether the API should automatically adjust the resolution for the specified timespan. Default is true.
    .PARAMETER clientId
    Filter results by client ID.
    .PARAMETER deviceSerial
    Filter results by access point serial.
    .PARAMETER apTag
    Filter results by access point tag.
    .PARAMETER band
    Filter results by band (either "2.4" or "5").
    .PARAMETER ssid
    Filter results by SSID number.
    .EXAMPLE
    PS> Get-MerakiNetworkWirelessSignalQualityHistory -AuthToken "1234" -networkId "abcd" -timespan 3600 -resolution 300
    Retrieves the signal quality history for the last hour for network "abcd" using the Meraki API token "1234", with a resolution of 5 minutes.
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/signalQualityHistory?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}