function Get-MerakiNetworkSmDeviceConnectivity {
    <#
    .SYNOPSIS
    Get the connectivity history of a device in a Meraki network.

    .DESCRIPTION
    This function retrieves the connectivity history of a device in a Meraki network using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The API key for the Meraki Dashboard.

    .PARAMETER NetworkId
    The ID of the Meraki network.

    .PARAMETER DeviceId
    The ID of the Meraki device to retrieve connectivity history for.

    .PARAMETER perPage
    The number of records per page to be returned.

    .PARAMETER startingAfter
    A token used by the API to indicate the starting point of the records to be returned.

    .PARAMETER endingBefore
    A token used by the API to indicate the end point of the records to be returned.

    .EXAMPLE
    Get-MerakiNetworkSmDeviceConnectivity -AuthToken $AuthToken -NetworkId $NetworkId -DeviceId $DeviceId

    This example retrieves the connectivity history for the specified Meraki device in the specified network.

    .NOTES
    For more information, see https://developer.cisco.com/meraki/api/#!get-network-sm-device-connectivity.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$true)]
        [string]$deviceId,
        [parameter(Mandatory=$false)]
        [int]$perPage,
        [parameter(Mandatory=$false)]
        [string]$startingAfter,
        [parameter(Mandatory=$false)]
        [string]$endingBefore
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $queryParams = @{}
    
        if ($perPage) {
            $queryParams['perPage'] = $perPage
        }
        if ($startingAfter) {
            $queryParams['startingAfter'] = $startingAfter
        }
        if ($endingBefore) {
            $queryParams['endingBefore'] = $endingBefore
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/sm/devices/$deviceId/connectivity?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
