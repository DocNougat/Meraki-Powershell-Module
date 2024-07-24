function Get-MerakiNetworkSmDevicePerformanceHistory {
    <#
    .SYNOPSIS
    Retrieves the performance history for a Systems Manager device.

    .DESCRIPTION
    The Get-MerakiNetworkSmDevicePerformanceHistory function retrieves the performance history for a Systems Manager device in a specified network. The function allows you to specify pagination parameters to control the number of records returned.

    .PARAMETER AuthToken
    The Meraki API token to use for the request.

    .PARAMETER NetworkId
    The ID of the network that contains the device.

    .PARAMETER DeviceId
    The ID of the device to retrieve performance history for.

    .PARAMETER PerPage
    The number of entries per page to be returned. Optional, default is 10.

    .PARAMETER StartingAfter
    A string representing the starting point for the next set of records to retrieve. Optional.

    .PARAMETER EndingBefore
    A string representing the ending point for the previous set of records to retrieve. Optional.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDevicePerformanceHistory -AuthToken '12345' -NetworkId 'N_1234' -DeviceId 'D_1234' -PerPage 50

    This example retrieves the performance history for the specified device, with 50 entries returned per page.

    .NOTES
    For more information on using the Meraki API, see https://developer.cisco.com/meraki/api-v1/.
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
        [int]$PerPage = 10,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore
    )

    $header = @{
        "X-Cisco-Meraki-API-Key" = $AuthToken
    }
    $queryParams = @{
        'perPage' = $PerPage
        'startingAfter' = $StartingAfter
        'endingBefore' = $EndingBefore
    }
    $queryString = New-MerakiQueryString -queryParams $queryParams
    $url = "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/performanceHistory?$queryString"
    $uri = [uri]::EscapeUriString($url)

    try {
        $response = Invoke-RestMethod -Method Get -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
