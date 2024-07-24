function Get-MerakiNetworkWirelessClientConnectionStats {
    <#
    .SYNOPSIS
    Retrieves connection statistics for a wireless client in a given Meraki network.

    .DESCRIPTION
    This function retrieves connection statistics for a wireless client in a given Meraki network using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The API token generated in the Meraki Dashboard.

    .PARAMETER NetworkId
    The ID of the Meraki network.

    .PARAMETER ClientId
    The ID of the wireless client.

    .PARAMETER t0
    The beginning of the timespan for the data. Defaults to null.

    .PARAMETER t1
    The end of the timespan for the data. Defaults to null.

    .PARAMETER timespan
    The timespan for which the data should be fetched, in seconds. Defaults to null.

    .PARAMETER band
    The wireless band to filter on. Defaults to null.

    .PARAMETER ssid
    The ID of the SSID to filter on. Defaults to null.

    .PARAMETER vlan
    The VLAN to filter on. Defaults to null.

    .PARAMETER apTag
    The tag of the AP to filter on. Defaults to null.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessClientConnectionStats -AuthToken '12345' -NetworkId 'N_1234567890' -ClientId 'C_1234567890'

    This command retrieves the connection statistics for the wireless client with the ID 'C_1234567890' in the Meraki network with the ID 'N_1234567890' using the API token '12345'.

    .INPUTS
    None.

    .OUTPUTS
    The function returns connection statistics for the specified wireless client.

    .NOTES
    For more information on the Meraki Dashboard API, please visit https://developer.cisco.com/meraki/api/.

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
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,        
        [parameter(Mandatory=$false)]
        [string]$band = $null,
        [parameter(Mandatory=$false)]
        [int]$ssid = $null,
        [parameter(Mandatory=$false)]
        [int]$vlan = $null,
        [parameter(Mandatory=$false)]
        [string]$apTag = $null
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/clients/$clientId/connectionStats?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response

    } catch {
        Write-Debug $_
        Throw $_
    }
}