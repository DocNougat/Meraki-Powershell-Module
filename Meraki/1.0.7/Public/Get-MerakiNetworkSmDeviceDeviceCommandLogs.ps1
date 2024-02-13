function Get-MerakiNetworkSmDeviceDeviceCommandLogs {
    <#
    .SYNOPSIS
    Gets the device command logs for a specified device in a Meraki network.

    .DESCRIPTION
    This function retrieves the device command logs for a specified device in a Meraki network using the Cisco Meraki Dashboard API. 

    .PARAMETER AuthToken
    The authorization token for the Meraki API.

    .PARAMETER NetworkId
    The ID of the network containing the device.

    .PARAMETER DeviceId
    The ID of the device to retrieve device command logs for.

    .PARAMETER perPage
    The number of entries per page returned. The maximum is 1000.

    .PARAMETER startingAfter
    A token used to retrieve the next page of results.

    .PARAMETER endingBefore
    A token used to retrieve the previous page of results.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceDeviceCommandLogs -AuthToken '1234' -NetworkId 'abcd' -DeviceId 'xyz' -perPage 100 -startingAfter 'abcd'

    This example retrieves the first 100 device command logs for the device with ID 'xyz' in the Meraki network with ID 'abcd', starting after the specified token.

    .NOTES
    #>
    param (
        [parameter(Mandatory = $true)]
        [string]$AuthToken,
        [parameter(Mandatory = $true)]
        [string]$NetworkId,
        [parameter(Mandatory = $true)]
        [string]$DeviceId,
        [parameter(Mandatory = $false)]
        [int]$perPage,
        [parameter(Mandatory = $false)]
        [string]$startingAfter,
        [parameter(Mandatory = $false)]
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
    
        $URL = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/deviceCommandLogs?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
