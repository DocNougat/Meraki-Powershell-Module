function Get-MerakiNetworkTraffic {
    <#
    .SYNOPSIS
    Retrieve traffic information for a network.

    .DESCRIPTION
    This function retrieves information about the traffic on a network, filtered by time and device type.

    .PARAMETER AuthToken
    The Meraki API token.

    .PARAMETER NetworkId
    The network ID.

    .PARAMETER t0
    The beginning of the timespan for the data. Defaults to 29 days ago.

    .PARAMETER deviceType
    The device type to filter by (e.g. "wireless", "switch", "appliance", or "cellular").

    .PARAMETER timespan
    The timespan for the data, in seconds. If not specified, the function will use the t0 parameter to calculate a 29-day timespan.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkTraffic -AuthToken "1234" -NetworkId "5678"

    Retrieves traffic information for the specified network.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkTraffic -AuthToken "1234" -NetworkId "5678" -t0 "2022-03-01T00:00:00Z" -deviceType "wireless"

    Retrieves traffic information for the specified network, filtered by wireless devices and a timespan starting from March 1st, 2022.

    .NOTES
    For more information, see the Meraki Dashboard API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-network-traffic
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
        [string]$deviceType = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null
    )

    try {
        if (!$t0){
            $29DaysAgo = (Get-Date).AddDays(-29)
            $t0 = Get-Date -Date $29DaysAgo -Format "o"
        }

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
        }
        if ($deviceType) {
            $queryParams['deviceType'] = $deviceType
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URI = "https://api.meraki.com/api/v1/networks/$networkId/traffic?$queryString"
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error $_
    }
}