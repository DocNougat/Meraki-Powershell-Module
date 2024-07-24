function Get-MerakiNetworkSyslogServers {
    <#
    .SYNOPSIS
    Retrieves the list of syslog servers configured for a given Meraki network.

    .PARAMETER AuthToken
    The API token for the Meraki dashboard.

    .PARAMETER NetworkId
    The ID of the Meraki network for which to retrieve syslog servers.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSyslogServers -AuthToken "1234" -NetworkId "L_1234"

    Retrieves the list of syslog servers for the Meraki network with ID "L_1234" using the API token "1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/syslogServers" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
