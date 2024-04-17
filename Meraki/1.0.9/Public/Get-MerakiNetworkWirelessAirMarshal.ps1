function Get-MerakiNetworkWirelessAirMarshal {
<#
.SYNOPSIS
Retrieves wireless air marshal information for a given Meraki network.

.DESCRIPTION
This function retrieves wireless air marshal information for a given Meraki network using the Meraki Dashboard API.

.PARAMETER AuthToken
The API token generated in the Meraki Dashboard.

.PARAMETER networkId
The ID of the Meraki network.

.PARAMETER t0
Optional. The beginning of the timespan for the data. ISO 8601 format is used (e.g. "2016-01-01T00:00:00Z").

.PARAMETER timespan
Optional. The timespan for which the information will be fetched, in seconds. The maximum value is 31 days (2678400 seconds).

.EXAMPLE
PS C:> Get-MerakiNetworkWirelessAirMarshal -AuthToken '12345' -networkId 'N_1234567890' -timespan 86400

This command retrieves the wireless air marshal information for the Meraki network with the ID 'N_1234567890' for the last 24 hours (86400 seconds) using the API token '12345'.

.INPUTS
None.

.OUTPUTS
The function returns a collection of wireless air marshal objects.

.NOTES
For more information on the Meraki Dashboard API, please visit https://developer.cisco.com/meraki/api/.

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
    [int]$timespan = $null
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
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/airMarshal?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}    