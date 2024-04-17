function Get-MerakiNetworkSmDevices {
    <#
    .SYNOPSIS
    Retrieves the list of devices enrolled in the Systems Manager for a given network.

    .DESCRIPTION
    This function retrieves the list of devices enrolled in the Systems Manager for a given network.
    
    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.
    
    .PARAMETER NetworkId
    Required. The network ID.
    
    .PARAMETER perPage
    Optional. The number of devices to return per page.
    
    .PARAMETER startingAfter
    Optional. A device ID to use as a starting point for the next page of results.
    
    .PARAMETER endingBefore
    Optional. A device ID to use as an ending point for the previous page of results.
    
    .PARAMETER fields
    Optional. An array of device fields to include in the response. If not specified, all fields are returned.
    
    .PARAMETER wifiMacs
    Optional. An array of WiFi MAC addresses to filter the results.
    
    .PARAMETER serials
    Optional. An array of serial numbers to filter the results.
    
    .PARAMETER ids
    Optional. An array of device IDs to filter the results.
    
    .PARAMETER scope
    Optional. An array of configuration profile IDs or tag IDs to filter the results.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDevices -AuthToken "12345" -NetworkId "L_1234" -perPage 50 -wifiMacs "00:11:22:33:44:55"
    
    Retrieves the first 50 devices with WiFi MAC address "00:11:22:33:44:55" in the network "L_1234".
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDevices -AuthToken "12345" -NetworkId "L_1234" -ids "12345","67890"
    
    Retrieves the devices with IDs "12345" and "67890" in the network "L_1234".
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [array]$fields = $null,
        [parameter(Mandatory=$false)]
        [array]$wifiMacs = $null,
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$ids = $null,
        [parameter(Mandatory=$false)]
        [array]$scope= $null
    )
    try{
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
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
        if ($fields) {
            $queryParams['fields[]'] = $fields
        }
        if ($wifiMacs) {
            $queryParams['wifiMacs[]'] = $wifiMacs
        }
        if ($serials) {
            $queryParams['serials[]'] = $serials
        }
        if ($ids) {
            $queryParams['ids[]'] = $ids
        }
        if ($scope) {
            $queryParams['scope[]'] = $scope
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URL = "https://api.meraki.com/api/v1/networks/$networkId/sm/devices?$queryString"
    
        $URI = [uri]::EscapeUriString($URL)
    
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}