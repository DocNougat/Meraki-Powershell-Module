function Get-MerakiNetworkWirelessClientCountHistory {
    <#
    .SYNOPSIS
    Retrieves the historical client count for a wireless network in Meraki Dashboard.
    .DESCRIPTION
    This function retrieves the historical client count for a wireless network in Meraki Dashboard using the Meraki REST API.
    .PARAMETER AuthToken
    The API token used to authenticate the request. This token can be generated in the Meraki Dashboard under Organization > Settings > Dashboard API access.
    .PARAMETER networkId
    The ID of the network to retrieve client count history for.
    .PARAMETER t0
    The beginning of the time range for the data. This parameter is ignored if timespan is provided.
    .PARAMETER t1
    The end of the time range for the data. This parameter is ignored if timespan is provided.
    .PARAMETER timespan
    The timespan of the data to retrieve, in seconds. If timespan is provided, t0 and t1 are ignored.
    .PARAMETER resolution
    The time resolution of the data to retrieve, in seconds. If AutoResolution is true, this parameter is ignored.
    .PARAMETER AutoResolution
    Whether or not the time resolution should be automatically determined based on the timespan. If true, resolution is ignored.
    .PARAMETER clientId
    The ID of the client to retrieve data for.
    .PARAMETER deviceSerial
    The serial number of the device to retrieve data for.
    .PARAMETER apTag
    The tag of the access point to retrieve data for.
    .PARAMETER band
    The band (either '2.4GHz' or '5GHz') to retrieve data for.
    .PARAMETER ssid
    The ID of the SSID to retrieve data for.
    .EXAMPLE
    PS C:\> Get-MerakiNetworkWirelessClientCountHistory -AuthToken $token -networkId $networkId -timespan 3600
    Retrieves the historical client count for the specified network for the past hour.
    .INPUTS
    None. You cannot pipe objects to this function.
    .OUTPUTS
    The function returns a collection of client count data objects, each containing the following properties:
    - clients: the number of clients for the specified criteria.
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
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null,
        [parameter(Mandatory=$false)]
        [int]$resolution = $null,
        [parameter(Mandatory=$false)]
        [bool]$AutoResolution = $true,
        [parameter(Mandatory=$false)]
        [string]$clientId = $null,
        [parameter(Mandatory=$false)]
        [string]$DeviceSerial = $null,
        [parameter(Mandatory=$false)]
        [string]$apTag = $null,
        [parameter(Mandatory=$false)]
        [string]$band = $null,
        [parameter(Mandatory=$false)]
        [int]$ssid = $null
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
    
        if ($AutoResolution) {
                $queryParams['AutoResolution'] = $AutoResolution
            }
    
        if ($clientId) {
                $queryParams['clientId'] = $clientId
            }
    
        if ($DeviceSerial) {
                $queryParams['deviceSerial'] = $DeviceSerial
            }
    
        if ($apTag) {
                $queryParams['apTag'] = $apTag
            }
    
        if ($band) {
                $queryParams['band'] = $band
            }
        if ($ssid) {
                $queryParams['ssid'] = $ssid
            }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/clientCountHistory?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}