function Get-MerakiDeviceClients {
    <#
.SYNOPSIS
    Retrieves the clients connected to a specified Meraki device.
.DESCRIPTION
    This function retrieves the clients connected to a specified Meraki device using the Meraki Dashboard API.
.PARAMETER AuthToken
    The API key for the Meraki Dashboard API.
.PARAMETER deviceSerial
    The serial number of the Meraki device for which to retrieve clients.
.PARAMETER t0
    The beginning of the timespan for which to retrieve clients. Optional.
.PARAMETER timespan
    The timespan for which to retrieve clients, in seconds. Optional.
.EXAMPLE
    PS C:\> Get-MerakiDeviceClients -AuthToken "12345" -deviceSerial "ABC123"
    Retrieves the clients connected to the device with serial number "ABC123" using the Meraki Dashboard API with API key "12345".
.NOTES
    For more information on the Meraki Dashboard API and retrieving clients, see the Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/#!get-device-clients
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
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

        $URL = "https://api.meraki.com/api/v1/devices/$DeviceSerial/clients?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}
