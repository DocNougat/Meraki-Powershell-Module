function Get-MerakiNetworkClientsApplicationUsage {
    <#
    .SYNOPSIS
    Retrieve the application usage history for clients on a network.

    .DESCRIPTION
    Use this API endpoint to get the application usage history for clients on a network. Clients can be identified by their MAC address or their IP address.

    .PARAMETER AuthToken
    The API key for the Meraki dashboard.

    .PARAMETER networkId
    The ID of the network.

    .PARAMETER clients
    The MAC or IP address of the client(s). Multiple clients can be specified by separating them with a comma.

    .PARAMETER ssidNumber
    The index of the SSID to query. This parameter is only valid for Wi-Fi networks.

    .PARAMETER perPage
    The number of entries per page returned. Maximum value is 1000.

    .PARAMETER startingAfter
    A token used to retrieve the next page of results. This is obtained from the "next" property in the response.

    .PARAMETER endingBefore
    A token used to retrieve the previous page of results. This is obtained from the "previous" property in the response.

    .PARAMETER t0
    The beginning of the timespan for the data. This can be a timestamp or an ISO 8601 formatted datetime string (YYYY-MM-DDTHH:MM:SSZ).

    .PARAMETER t1
    The end of the timespan for the data. This can be a timestamp or an ISO 8601 formatted datetime string (YYYY-MM-DDTHH:MM:SSZ).

    .PARAMETER timespan
    The timespan for which the data should be fetched, in seconds. The maximum value is 2678400 seconds (31 days).

    .EXAMPLE
    PS C:\> Get-MerakiNetworkClientsApplicationUsage -AuthToken $AuthToken -networkId $NetworkId -clients "00:11:22:33:44:55" -ssidNumber 1 -timespan 86400

    This command retrieves the application usage history for the client with MAC address "00:11:22:33:44:55" on the network with ID $NetworkId. It filters the results to only show data for SSID 1 and a timespan of 24 hours.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkClientsApplicationUsage -AuthToken $AuthToken -networkId $NetworkId -clients "192.168.1.10,192.168.1.20" -perPage 1000

    This command retrieves the application usage history for the clients with IP addresses "192.168.1.10" and "192.168.1.20" on the network with ID $NetworkId. It returns up to 1000 entries per page.

    .NOTES
    For more information, see the Meraki API documentation: https://developer.cisco.com/meraki/api-v1/#!get-network-clients-application-usage

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$clients,
        [parameter(Mandatory=$false)]
        [int]$ssidNumber = $null,
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
        [int]$timespan = $null
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/clients?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}