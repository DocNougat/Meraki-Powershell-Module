function Get-MerakiOrganizationDevicesAvailabilitiesChangeHistory {
    <#
    .SYNOPSIS
    Retrieves the device availabilities history for an organization in the Meraki Dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationDevicesAvailabilitiesChangeHistory function retrieves the device availabilities history for an organization in the Meraki Dashboard using the Meraki Dashboard API. This function requires an API key for authentication.

    .PARAMETER AuthToken
    The Meraki Dashboard API key for authentication.

    .PARAMETER OrgId
    The organization ID. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER perPage
    The number of devices to return per page. If not specified, the default value is used.

    .PARAMETER startingAfter
    The device serial number to start the page with. If not specified, the first page is used.

    .PARAMETER endingBefore
    The device serial number to end the page with. If not specified, the last page is used.

    .PARAMETER networkIds
    An array of network IDs to filter the devices by. If not specified, all devices are returned.

    .PARAMETER productTypes
    An array of product types to filter the devices by. If not specified, all devices are returned.

    .PARAMETER serials
    An array of device serial numbers to filter the devices by. If not specified, all devices are returned.

    .PARAMETER t0
    The beginning of the timespan for the data. The maximum lookback period is 31 days from today.

    .PARAMETER t1
    The end of the timespan for the data. t1 can be a maximum of 31 days after t0.

    .PARAMETER timespan
    The timespan for which the information will be fetched. If specifying timespan, do not specify parameters t0 and t1. The value must be in seconds and be less than or equal to 31 days. The default is 1 day.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationDevicesAvailabilitiesChangeHistory -AuthToken "1234567890abcdef" -OrgId "1234567890" -perPage 50 -serials "Q2FN-3V7D-JN25"

    This example retrieves the device availability History for an organization with ID "1234567890", filtering by the device with serial number "Q2FN-3V7D-JN25" and returning 50 devices per page.

    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [int]$perPage = $null,
        [parameter(Mandatory=$false)]
        [string]$startingAfter = $null,
        [parameter(Mandatory=$false)]
        [string]$endingBefore = $null,
        [parameter(Mandatory=$false)]
        [array]$networkIds = $null,
        [parameter(Mandatory=$false)]
        [array]$productTypes = $null,
        [parameter(Mandatory=$false)]
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        Try {
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
            if ($networkIds) {
                $queryParams['networkIds[]'] = $networkIds
            }
            if ($productTypes) {
                $queryParams['productTypes[]'] = $productTypes
            }
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($t0) {
                $queryParams['t0[]'] = $t0
            }
            if ($t1) {
                $queryParams['t1'] = $t1
            }
            if ($timespan) {
                $queryParams['timespan'] = $timespan
            }        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/devices/availabilities/changeHistory?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}