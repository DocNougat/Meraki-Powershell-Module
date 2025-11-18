function Get-MerakiNetworkWirelessChannelUtilizationHistory {
    <#
    .SYNOPSIS
    Retrieves channel utilization history for a given Meraki network.

    .DESCRIPTION
    This function retrieves channel utilization history for a given Meraki network using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The API token generated in the Meraki Dashboard.

    .PARAMETER networkId
    The ID of the Meraki network.

    .PARAMETER t0
    The beginning of the timespan for the data. The maximum lookback period is 31 days from today.

    .PARAMETER t1
    The end of the timespan for the data. t1 can be a maximum of 31 days after t0.

    .PARAMETER timespan
    The timespan for which the information will be fetched. This should be in seconds and can have a maximum value of 31 days.

    .PARAMETER resolution
    The time resolution in seconds for returned data. The valid resolutions are: 60, 600, 3600, 14400, 86400. The default is 60.

    .PARAMETER AutoResolution
    Boolean indicating whether or not automatically choose a resolution for returned data. The default is true.

    .PARAMETER clientId
    The client ID for which the data should be fetched.

    .PARAMETER deviceSerial
    The serial number of the device for which the data should be fetched.

    .PARAMETER apTag
    The AP tag for which the data should be fetched.

    .PARAMETER band
    The wireless band (either "2.4G" or "5G") for which the data should be fetched.

    .EXAMPLE
    PS C:> Get-MerakiNetworkWirelessChannelUtilizationHistory -AuthToken '12345' -networkId 'N_1234567890' -timespan 86400

    This command retrieves the channel utilization history for the Meraki network with the ID 'N_1234567890' over the last 24 hours using the API token '12345'.

    .INPUTS
    None.

    .OUTPUTS
    The function returns a collection of channel utilization objects.

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
    [string]$band = $null
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

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $URL = "https://api.meraki.com/api/v1/networks/$networkId/wireless/channelUtilizationHistory?$queryString"

        $URI = [uri]::EscapeUriString($URL)

        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }