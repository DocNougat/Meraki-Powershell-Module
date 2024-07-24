function Get-MerakiNetworkBluetoothClients {
    <#
    .SYNOPSIS
    Get a list of Bluetooth clients associated with a network.

    .DESCRIPTION
    Returns a list of all Bluetooth clients seen by APs in the network. If a given client has
    been seen by multiple APs, an entry will be returned for each AP.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The network ID.

    .PARAMETER t0
    The beginning of the timespan for the data. The maximum lookback period is 365 days from
    the current date. The default is the past 7 days.

    .PARAMETER timespan
    The timespan for which the data should be fetched. The default is 1 day.

    .PARAMETER perPage
    The number of entries per page returned. The default is 10.

    .PARAMETER startingAfter
    A token used by the server to indicate where to start fetching the next page of results.

    .PARAMETER endingBefore
    A token used by the server to indicate where to stop fetching results.

    .PARAMETER includeConnectivityHistory
    Whether or not to include connectivity history in the response. The default is $true.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkBluetoothClients -AuthToken "1234" -NetworkId "N_1234" -t0 "2022-03-01T00:00:00Z" -timespan 3600

    Returns a list of all Bluetooth clients seen by APs in the network between March 1st, 2022 and
    the current time with a timespan of 1 hour.

    .NOTES
    For more information, please see:
    https://developer.cisco.com/meraki/api-v1/#!get-network-bluetooth-clients
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$true)]
        [string]$bluetoothClientId,
        [parameter(Mandatory=$false)]
        [bool]$includeConnectivityHistory = $true
        )
    try{
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $queryParams = @{}
        
            if ($timespan) {
                $queryParams['timespan'] = $timespan
            } else {
                if ($t0) {
                    $queryParams['t0'] = $t0
                    }
                }
            if ($perPage) {
                    $queryParams['perPage'] = $perPage
                }
            if ($startingAfter) {
                    $queryParams['startingAfter'] = $startingAfter
                }
            if ($endingBefore) {
                    $queryParams['endingBefore'] = $endingBefore
                }
            if ($includeConnectivityHistory) {
                    $queryParams['includeConnectivityHistory'] = $includeConnectivityHistory
                    }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/networks/$networkId/bluetoothClients?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response    
    } catch {
        Write-Debug $_
        Throw $_
    }
}