Function Get-MerakiNetworkWirelessConnectionStats {
    <#
    .SYNOPSIS
    Get connection statistics for a Meraki wireless network.

    .DESCRIPTION
    This function retrieves connection statistics for a Meraki wireless network. You can specify the time range for which to retrieve data using either the `timespan` parameter or the `t0` and `t1` parameters. You can also filter the results by band, SSID, VLAN, or access point tag.

    .PARAMETER AuthToken
    The Meraki API token for your organization.

    .PARAMETER NetworkId
    The ID of the Meraki wireless network for which to retrieve connection statistics.

    .PARAMETER T0
    The beginning of the time range for which to retrieve data, in ISO 8601 format (e.g. "2021-04-01T00:00:00Z"). This parameter is optional if `timespan` is specified.

    .PARAMETER T1
    The end of the time range for which to retrieve data, in ISO 8601 format. This parameter is optional if `timespan` is specified.

    .PARAMETER Timespan
    The time range for which to retrieve data, in seconds. This parameter is optional if `t0` and `t1` are specified.

    .PARAMETER Band
    The wireless band for which to retrieve connection statistics. Valid values are "2.4G" and "5G".

    .PARAMETER SSID
    The ID of the SSID for which to retrieve connection statistics.

    .PARAMETER VLAN
    The ID of the VLAN for which to retrieve connection statistics.

    .PARAMETER APTag
    The tag of the access point for which to retrieve connection statistics.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessConnectionStats -AuthToken "1234567890abcdef" -NetworkId "L_1234567890" -T0 "2021-04-01T00:00:00Z" -T1 "2021-04-02T00:00:00Z" -Band "2.4G" -SSID 1 -VLAN 10 -APTag "office"

    Retrieves connection statistics for the specified network for the time range of April 1, 2021 to April 2, 2021, filtered by the 2.4GHz band, SSID ID 1, VLAN ID 10, and access point tag "office".

    .NOTES
    For more information on using the Meraki API, see the official documentation:
    https://developer.cisco.com/meraki/api-v1/

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$false)]
        [string]$T0 = $null,
        [Parameter(Mandatory=$false)]
        [string]$T1 = $null,
        [Parameter(Mandatory=$false)]
        [int]$Timespan = $null,
        [Parameter(Mandatory=$false)]
        [string]$Band = $null,
        [Parameter(Mandatory=$false)]
        [int]$SSID = $null,
        [Parameter(Mandatory=$false)]
        [int]$VLAN = $null,
        [Parameter(Mandatory=$false)]
        [string]$APTag = $null
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/connectionStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}