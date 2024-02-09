function Get-MerakiNetworkClientsOverview {
    <#
    .SYNOPSIS
    Retrieve an overview of client usage data for a given network.

    .DESCRIPTION
    Use this API endpoint to retrieve client usage data for a given network, including usage by application and operating system.

    .PARAMETER AuthToken
    Meraki Dashboard API key.

    .PARAMETER networkId
    The ID of the network for which to retrieve client usage data.

    .PARAMETER t0
    The beginning of the timespan for which client usage data should be retrieved. This parameter is optional, but must be specified if timespan is not.

    .PARAMETER t1
    The end of the timespan for which client usage data should be retrieved. This parameter is optional, but must be specified if timespan is not.

    .PARAMETER timespan
    The timespan, in seconds, for which client usage data should be retrieved. This parameter is optional, but must be specified if t0 and t1 are not.

    .PARAMETER resolution
    The time resolution, in seconds, for the returned data. The default is 3600 seconds (one hour). Valid values are 60, 600, 3600, and 86400.

    .EXAMPLE
    Get-MerakiNetworkClientsOverview -AuthToken $AuthToken -networkId $networkId -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-02T00:00:00Z"

    Retrieves client usage data for the specified network for the timespan between 2022-01-01T00:00:00Z and 2022-01-02T00:00:00Z.

    .EXAMPLE
    Get-MerakiNetworkClientsOverview -AuthToken $AuthToken -networkId $networkId -timespan 86400 -resolution 600

    Retrieves client usage data for the specified network for the past 24 hours, with a time resolution of 10 minutes.

    #>
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
        [int]$resolution = $null

    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($resolution) {
            $queryParams['resolution'] = $resolution
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
        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$networkId/clients/overview?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}
