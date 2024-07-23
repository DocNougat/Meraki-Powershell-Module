function Get-MerakiNetworkApplianceUplinksUsageHistory {
    <#
    .SYNOPSIS
    Gets the uplink usage history for a network's appliance.

    .DESCRIPTION
    This function retrieves the uplink usage history for a network's appliance. You can specify a time range using either the timespan or t0 and t1 parameters. The resolution parameter controls the granularity of the data returned.

    .PARAMETER AuthToken
    The Meraki Dashboard API authentication token.

    .PARAMETER NetworkId
    The ID of the network for which to retrieve the uplink usage history.

    .PARAMETER t0
    The beginning of the time range for which to retrieve data. This parameter is optional.

    .PARAMETER t1
    The end of the time range for which to retrieve data. This parameter is optional.

    .PARAMETER timespan
    The duration of the time range for which to retrieve data, in seconds. This parameter is optional.

    .PARAMETER resolution
    The granularity of the data returned, in seconds. This parameter is optional.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkApplianceUplinksUsageHistory -AuthToken "1234" -NetworkId "abcd" -timespan 86400 -resolution 3600

    This command retrieves the uplink usage history for the network with ID "abcd" for the past 24 hours, with data points every hour.

    .NOTES
    For more information, see https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-uplinks-usage-history.
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
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$resolution = $null
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "Content-Type" = "application/json"
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

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/uplinks/usageHistory?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}