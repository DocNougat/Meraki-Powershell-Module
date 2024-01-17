function Get-MerakiNetworkWirelessClientConnectivityEvents {
    <#
    .SYNOPSIS
    Retrieves the connectivity events of a wireless client from a Meraki network.

    .DESCRIPTION
    This function retrieves the connectivity events of a wireless client from a Meraki network.
    It requires an authentication token and the ID of the network and client.
    Other optional parameters can be used to filter the results by severity, type, time range, band, SSID, and device serial.

    .PARAMETER AuthToken
    The authentication token obtained from the Meraki dashboard.

    .PARAMETER NetworkId
    The ID of the Meraki network to query.

    .PARAMETER ClientId
    The ID of the Meraki client to retrieve connectivity events for.

    .PARAMETER PerPage
    The number of entries per page returned. Must be between 3 and 1000. Default is 10.

    .PARAMETER StartingAfter
    A token used to retrieve the next page of results after a previous API call.

    .PARAMETER EndingBefore
    A token used to retrieve the previous page of results before a previous API call.

    .PARAMETER t0
    The beginning of the time range to query. Can be a timestamp in ISO 8601 format or a string in natural language (e.g. "1 hour ago").

    .PARAMETER t1
    The end of the time range to query. Can be a timestamp in ISO 8601 format or a string in natural language (e.g. "1 hour ago").

    .PARAMETER Timespan
    The length of the time range to query in seconds.

    .PARAMETER Types
    An array of connectivity event types to include in the results.

    .PARAMETER IncludedSeverities
    An array of severities to include in the results.

    .PARAMETER Band
    The radio band to query. Can be "2.4GHz" or "5GHz".

    .PARAMETER SsidNumber
    The SSID number to query. Must be an integer.

    .PARAMETER DeviceSerial
    The serial number of the access point to query.

    .EXAMPLE
    Get-MerakiNetworkWirelessClientConnectivityEvents -AuthToken $AuthToken -NetworkId $NetworkId -ClientId $ClientId

    This example retrieves all the connectivity events for a wireless client.

    .EXAMPLE
    Get-MerakiNetworkWirelessClientConnectivityEvents -AuthToken $AuthToken -NetworkId $NetworkId -ClientId $ClientId -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-02T00:00:00Z"

    This example retrieves all the connectivity events for a wireless client that occurred on January 1, 2022.

    .NOTES
    For more information, see the official Meraki API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-wireless-client-connectivity-events
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
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [array]$types = $null,
        [parameter(Mandatory=$false)]
        [array]$includedSeverities = $null,
        [parameter(Mandatory=$false)]
        [string]$band = $null,
        [parameter(Mandatory=$false)]
        [int]$ssidNumber = $null,
        [parameter(Mandatory=$false)]
        [string]$DeviceSerial = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($perPage) {
            $queryParams['perPage'] = $perPage
        }
    
        if ($startingAfter) {
            $queryParams['startingAfter'] = $startingAfter
        }
    
        if ($endingBefore) {
            $queryParams['endingBefore'] = $endingBefore
        }
    
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
    
        if ($types) {
                $queryParams['types[]'] = $types
            }
    
        if ($includedSeverities) {
                $queryParams['includedSeverities[]'] = $includedSeverities
            }
    
        if ($band) {
                $queryParams['band'] = $band
            }
    
        if ($ssidNumber) {
                $queryParams['ssidNumber'] = $ssidNumber
            }
    
        if ($DeviceSerial) {
                $queryParams['deviceSerial'] = $DeviceSerial
            }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/clients/$clientId/connectivityEvents?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error $_
    }
}