function Get-MerakiDeviceWirelessLatencyStats {
<#
        .SYNOPSIS
        Retrieves wireless latency statistics for a Meraki device.

        .DESCRIPTION
        This function retrieves wireless latency statistics for a specified Meraki device over a given time period. The results can be filtered by access point, band, SSID, VLAN, and fields. 

        .PARAMETER AuthToken
        The Meraki API token to use for authentication.

        .PARAMETER deviceSerial
        The serial number of the Meraki device to retrieve statistics for.

        .PARAMETER t0
        The beginning of the time range to retrieve statistics for, in ISO 8601 format. Either t0 and t1 or timespan can be used, but not both.

        .PARAMETER t1
        The end of the time range to retrieve statistics for, in ISO 8601 format. Either t0 and t1 or timespan can be used, but not both.

        .PARAMETER timespan
        The timespan to retrieve statistics for, in seconds. Either t0 and t1 or timespan can be used, but not both.

        .PARAMETER apTag
        The tag of the access point to retrieve statistics for.

        .PARAMETER band
        The wireless band to retrieve statistics for. Must be either "2.4" or "5".

        .PARAMETER ssid
        The ID of the SSID to retrieve statistics for.

        .PARAMETER vlan
        The VLAN to retrieve statistics for.

        .PARAMETER fields
        A comma-separated list of fields to retrieve statistics for. Must be one or more of "rawDistribution", "avgLatencyMs", "avgAssocLatencyMs", "avgAuthLatencyMs", "avgDHCPLatencyMs", "avgDnsLatencyMs", "avgHandoffLatencyMs", "avgTxLatencyMs", "avgRxLatencyMs", "avgAirtimeUtilizationPercent", "numStations".

        .EXAMPLE
        PS C:\> Get-MerakiDeviceWirelessLatencyStats -AuthToken $AuthToken -deviceSerial "Q2HX-XXXX-XXXX" -t0 "2022-04-01T00:00:00Z" -t1 "2022-04-30T00:00:00Z" -band "5"

        Retrieves wireless latency statistics for the device with serial number "Q2HX-XXXX-XXXX" for the month of April 2022 for the 5 GHz band.

        .NOTES
        For more information, see the Meraki API documentation: https://developer.cisco.com/meraki/api-v1/#!get-device-wireless-latency-stats
        #>
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
        
            $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/wireless/latencyStats?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
}