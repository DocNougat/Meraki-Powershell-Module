function Get-MerakiNetworkSmDeviceDesktopLogs {
    <#
    .SYNOPSIS
    Retrieves desktop logs of a specific device in a Meraki network.

    .DESCRIPTION
    The Get-MerakiNetworkSmDeviceDesktopLogs function retrieves desktop logs of a specific device in a Meraki network.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER NetworkId
    The ID of the network in which the device resides.

    .PARAMETER DeviceId
    The ID of the device to retrieve desktop logs from.

    .PARAMETER PerPage
    The number of entries per page to return.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page. Used for pagination.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page. Used for pagination.

    .EXAMPLE
    Get-MerakiNetworkSmDeviceDesktopLogs -AuthToken $token -NetworkId N_1234 -DeviceId A_5678 -PerPage 50

    Retrieves the last 50 entries of desktop logs for device A_5678 in network N_1234.

    .NOTES
    For more information on the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$DeviceId,
        [parameter(Mandatory=$false)]
        [int]$PerPage,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
        if ($PerPage) {
            $queryParams['perPage'] = $PerPage
        }
        if ($StartingAfter) {
            $queryParams['startingAfter'] = $StartingAfter
        }
        if ($EndingBefore) {
            $queryParams['endingBefore'] = $EndingBefore
        }
        $queryString = New-MerakiQueryString -queryParams $queryParams
        $URL = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/desktopLogs?$queryString"
        $URI = [uri]::EscapeUriString($URL)
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
