function Get-MerakiNetworkClientsUsageHistories {
    <#
        .SYNOPSIS
        Retrieves the usage histories for the clients of a given network.

        .DESCRIPTION
        This function retrieves the usage histories for the clients of a given network, according to the specified parameters.

        .PARAMETER AuthToken
        The Meraki API token to be used for the request.

        .PARAMETER NetworkId
        The ID of the network whose clients' usage histories are to be retrieved.

        .PARAMETER Clients
        The MAC addresses of the clients whose usage histories are to be retrieved. Multiple MAC addresses can be specified by separating them with commas.

        .PARAMETER SSIDNumber
        The number of the SSID whose clients' usage histories are to be retrieved. If not specified, usage histories for all SSIDs will be retrieved.

        .PARAMETER PerPage
        The number of entries per page to include in the response. If not specified, the default value of 1000 will be used.

        .PARAMETER StartingAfter
        A pagination parameter indicating the starting client whose usage history records should be included in the response.

        .PARAMETER EndingBefore
        A pagination parameter indicating the ending client whose usage history records should be included in the response.

        .PARAMETER T0
        The beginning of the time range for which to retrieve usage history records. This should be specified as a UNIX timestamp in seconds.

        .PARAMETER T1
        The end of the time range for which to retrieve usage history records. This should be specified as a UNIX timestamp in seconds.

        .PARAMETER Timespan
        The timespan for which to retrieve usage history records, in seconds. If specified, this will override the T0 and T1 parameters.

        .EXAMPLE
        PS C:\> Get-MerakiNetworkClientsUsageHistories -AuthToken "12345" -NetworkId "N_1234" -Clients "00:11:22:33:44:55, 11:22:33:44:55:66" -SSIDNumber 1 -Timespan 3600

        Retrieves the usage histories for the clients with MAC addresses 00:11:22:33:44:55 and 11:22:33:44:55:66 on SSID 1 of the network with ID "N_1234" for the past hour.

        .NOTES
        For more information on the API endpoint this function uses, see the following documentation:

        https://developer.cisco.com/meraki/api-v1/#!get-network-clients-usage-histories
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$Clients,
        [parameter(Mandatory=$false)]
        [int]$SSIDNumber,
        [parameter(Mandatory=$false)]
        [int]$PerPage = 1000,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore,
        [parameter(Mandatory=$false)]
        [string]$T0,
        [parameter(Mandatory=$false)]
        [string]$T1,
        [parameter(Mandatory=$false)]
        [int]$Timespan
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
    
        $queryParams['clients'] = $clients
    
        if ($ssidNumber) {
            $queryParams['ssidNumber'] = $ssidNumber
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/clients/usageHistories?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}