function Get-MerakiNetworkEvents {
    <#
    .SYNOPSIS
        Retrieves events for a specific Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER OrgId
        The ID of the organization. Default is the ID of the first organization returned by Get-MerakiOrganizations.

    .PARAMETER networkId
        The ID of the Meraki network.

    .PARAMETER productType
        The type of Meraki product. Default is null.

    .PARAMETER includedEventTypes
        An array of event types to include. Default is null.

    .PARAMETER excludedEventTypes
        An array of event types to exclude. Default is null.

    .PARAMETER deviceMac
        The MAC address of the device associated with the event. Default is null.

    .PARAMETER deviceSerial
        The serial number of the device associated with the event. Default is null.

    .PARAMETER deviceName
        The name of the device associated with the event. Default is null.

    .PARAMETER clientIp
        The IP address of the client associated with the event. Default is null.

    .PARAMETER clientMac
        The MAC address of the client associated with the event. Default is null.

    .PARAMETER clientName
        The name of the client associated with the event. Default is null.

    .PARAMETER smDeviceMac
        The MAC address of the Systems Manager device associated with the event. Default is null.

    .PARAMETER smDeviceName
        The name of the Systems Manager device associated with the event. Default is null.

    .PARAMETER perPage
        The number of entries per page. Default is null.

    .PARAMETER startingAfter
        A starting timestamp for the query. Default is null.

    .PARAMETER endingBefore
        An ending timestamp for the query. Default is null.

    .EXAMPLE
        Get-MerakiNetworkEvents -AuthToken "YOUR_API_KEY" -networkId "YOUR_NETWORK_ID"

        Retrieves events for the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$networkId,
        [parameter(Mandatory=$false)]
        [string]$productType = $null,
        [parameter(Mandatory=$false)]
        [array]$includedEventTypes = $null,
        [parameter(Mandatory=$false)]
        [array]$excludedEventTypes = $null,
        [parameter(Mandatory=$false)]
        [string]$deviceMac = $null,
        [parameter(Mandatory=$false)]
        [string]$DeviceSerial = $null,
        [parameter(Mandatory=$false)]
        [string]$deviceName = $null,
        [parameter(Mandatory=$false)]
        [string]$clientIp = $null,
        [parameter(Mandatory=$false)]
        [string]$clientMac = $null,
        [parameter(Mandatory=$false)]
        [string]$clientName = $null,
        [parameter(Mandatory=$false)]
        [string]$smDeviceMac = $null,
        [parameter(Mandatory=$false)]
        [string]$smDeviceName = $null,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "Content-Type" = "application/json"
        }
        $queryParams = @{}
        if ($productType) {
            $queryParams['productType'] = $productType
        }
        if ($includedEventTypes) {
            $queryParams['includedEventTypes[]'] = $includedEventTypes
        }
        if ($excludedEventTypes) {
            $queryParams['excludedEventTypes[]'] = $excludedEventTypes
        }
        if ($deviceMac) {
            $queryParams['deviceMac'] = $deviceMac
        }
        if ($DeviceSerial) {
            $queryParams['deviceSerial'] = $DeviceSerial
        }
        if ($deviceName) {
            $queryParams['deviceName'] = $deviceName
        }
        if ($clientIp) {
            $queryParams['clientIp'] = $clientIp
        }
        if ($clientMac) {
            $queryParams['clientMac'] = $clientMac
        }
        if ($clientName) {
            $queryParams['clientName'] = $clientName
        }
        if ($smDeviceMac) {
            $queryParams['smDeviceMac'] = $smDeviceMac
        }
        if ($smDeviceName) {
            $queryParams['smDeviceName'] = $smDeviceName
        }
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
        $URI = "https://api.meraki.com/api/v1/networks/$networkId/events?$queryString"
        $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    } catch {
        Write-Debug $_
        Throw $_
    }
}