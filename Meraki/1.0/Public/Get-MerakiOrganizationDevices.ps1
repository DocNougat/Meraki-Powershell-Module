function Get-MerakiOrganizationDevices {
    <#
    .SYNOPSIS
    Retrieves a list of devices in an organization.

    .DESCRIPTION
    Retrieves a list of devices in an organization that meet the specified filter criteria.

    .PARAMETER AuthToken
    The Meraki API token to use for authentication.

    .PARAMETER OrgId
    The organization ID to retrieve devices for. If not specified, the ID of the first organization will be used.

    .PARAMETER perPage
    The number of devices to return per page. Maximum is 1000.

    .PARAMETER startingAfter
    The starting device serial number for the page of results.

    .PARAMETER endingBefore
    The ending device serial number for the page of results.

    .PARAMETER configurationUpdatedAfter
    The earliest configuration update time for the devices.

    .PARAMETER networkIds
    An array of network IDs to filter the devices by.

    .PARAMETER productTypes
    An array of product types to filter the devices by.

    .PARAMETER tags
    An array of tags to filter the devices by.

    .PARAMETER tagsFilterType
    The tag filter type to use. Valid values are "withAnyTags" and "withAllTags".

    .PARAMETER name
    The name of the device to filter by.

    .PARAMETER serial
    The serial number of the device to filter by.

    .PARAMETER model
    The model of the device to filter by.

    .PARAMETER macs
    An array of MAC addresses to filter the devices by.

    .PARAMETER serials
    An array of serial numbers to filter the devices by.

    .PARAMETER sensorMetrics
    An array of sensor metrics to filter the devices by.

    .PARAMETER sensorAlertProfileIds
    An array of sensor alert profile IDs to filter the devices by.

    .PARAMETER models
    An array of models to filter the devices by.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationDevices -AuthToken "1234" -OrgId "5678"

    Retrieves a list of devices in the organization with ID "5678".

    .NOTES
    For more information, see the Meraki API documentation:
    https://developer.cisco.com/meraki/api-v1/#!get-organizations-organizationId-devices

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organizations-organizationId-devices
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-MerakiOrganizations -AuthToken $AuthToken).id,
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [string]$configurationUpdatedAfter = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null,
        [parameter(Mandatory=$false)]
        [array]$productTypes = $null,
        [parameter(Mandatory=$false)]
        [array]$tags = $null,
        [parameter(Mandatory=$false)]
        [string]$tagsFilterType = $null,
        [parameter(Mandatory=$false)]
        [string]$name = $null,
        [parameter(Mandatory=$false)]
        [string]$serial = $null,
        [parameter(Mandatory=$false)]
        [string]$model = $null,
        [parameter(Mandatory=$false)]
        [array]$macs = $null,
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$sensorMetrics = $null,
        [parameter(Mandatory=$false)]
        [array]$sensorAlertProfileIds = $null,
        [parameter(Mandatory=$false)]
        [array]$models = $null
    )
    try{
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "Content-Type" = "application/json"
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
        if ($configurationUpdatedAfter) {
            $queryParams['configurationUpdatedAfter'] = $configurationUpdatedAfter
        }
        if ($networkIds) {
            $queryParams['networkIds[]'] = $networkIds
        }
        if ($productTypes) {
            $queryParams['productTypes[]'] = $productTypes
        }
        if ($tags) {
            $queryParams['tags[]'] = $tags
        }
        if ($tagsFilterType) {
            $queryParams['tagsFilterType'] = $tagsFilterType
        }
        if ($name) {
            $queryParams['name'] = $name
        }
        if ($serial) {
            $queryParams['serial'] = $serial
        }
        if ($model) {
            $queryParams['model'] = $model
        }
        if ($macs) {
            $queryParams['macs[]'] = $macs
        }
        if ($serials) {
            $queryParams['serials[]'] = $serials
        }
        if ($sensorMetrics) {
            $queryParams['sensorMetrics[]'] = $sensorMetrics
        }
        if ($sensorAlertProfileIds) {
            $queryParams['sensorAlertProfileIds[]'] = $sensorAlertProfileIds
        }
        if ($models) {
            $queryParams['models[]'] = $models
        }
    
        $queryString = New-MerakiQueryString -queryParams $queryParams
    
        $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices?$queryString"
        $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
        return $response
    } catch {
        Write-Error $_
    }
}