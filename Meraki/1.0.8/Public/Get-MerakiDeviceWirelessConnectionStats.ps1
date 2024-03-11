function Get-MerakiDeviceWirelessConnectionStats {
     <#
    .SYNOPSIS
    Retrieves wireless connection stats for a device.
    
    .DESCRIPTION
    Retrieves wireless connection stats for a device within a specified time range, band, SSID, VLAN, or AP tag.
    
    .PARAMETER AuthToken
    The authorization token for the Meraki dashboard API.
    
    .PARAMETER deviceSerial
    The serial number of the device to retrieve wireless connection stats for.
    
    .PARAMETER t0
    The beginning of the time range for which to retrieve wireless connection stats. This parameter is optional if `timespan` is used instead.
    
    .PARAMETER t1
    The end of the time range for which to retrieve wireless connection stats. This parameter is optional if `timespan` is used instead.
    
    .PARAMETER timespan
    The timespan for which to retrieve wireless connection stats. This parameter is optional if `t0` and `t1` are used instead.
    
    .PARAMETER band
    The band for which to retrieve wireless connection stats. This parameter is optional.
    
    .PARAMETER ssid
    The SSID for which to retrieve wireless connection stats. This parameter is optional.
    
    .PARAMETER vlan
    The VLAN for which to retrieve wireless connection stats. This parameter is optional.
    
    .PARAMETER apTag
    The AP tag for which to retrieve wireless connection stats. This parameter is optional.
    
    .EXAMPLE
    PS C:\> Get-MerakiDeviceWirelessConnectionStats -AuthToken "12345" -deviceSerial "Q2FD-3EG5-2QXS" -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-02T00:00:00Z"
    
    Retrieves wireless connection stats for the device with serial number "Q2FD-3EG5-2QXS" for the time range between January 1st, 2022 and January 2nd, 2022.
    
    .NOTES
    For more information on the Meraki dashboard API and the `Get-MerakiDeviceWirelessConnectionStats` endpoint, see the Meraki API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-device-wireless-connection-stats
    
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
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

        $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/connectionStats?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}