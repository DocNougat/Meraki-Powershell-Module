function Get-MerakiNetworkWirelessClientLatencyHistory {
    <#
.SYNOPSIS
   Retrieves the historical latency data for a wireless client in Meraki Dashboard.
.DESCRIPTION
   This function retrieves the historical latency data for a wireless client in Meraki Dashboard using the Meraki REST API.
.PARAMETER AuthToken
   The API token used to authenticate the request. This token can be generated in the Meraki Dashboard under Organization > Settings > Dashboard API access.
.PARAMETER networkId
   The ID of the network containing the client to retrieve latency data for.
.PARAMETER clientId
   The ID of the client to retrieve latency data for.
.PARAMETER t0
   The beginning of the time range for the data. This parameter is ignored if timespan is provided.
.PARAMETER t1
   The end of the time range for the data. This parameter is ignored if timespan is provided.
.PARAMETER timespan
   The timespan of the data to retrieve, in seconds. If timespan is provided, t0 and t1 are ignored.
.PARAMETER resolution
   The time resolution of the data to retrieve, in seconds.
.EXAMPLE
   PS C:\> Get-MerakiNetworkWirelessClientLatencyHistory -AuthToken $token -networkId $networkId -clientId $clientId -timespan 3600
   Retrieves the historical latency data for the specified client for the past hour.
.INPUTS
   None. You cannot pipe objects to this function.
.OUTPUTS
   The function returns a collection of latency data objects, each containing the following properties:
   - latencyMs: the latency in milliseconds.
   - ts: the timestamp for the data in UNIX timestamp format.
.NOTES
   This function requires the Meraki PowerShell module, which can be installed from the PowerShell Gallery using the following command:
   Install-Module -Name Meraki
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
        [int]$resolution = $null
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
    
        if ($resolution) {
            $queryParams['resolution'] = $resolution
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/clients/$clientId/latencyHistory?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}