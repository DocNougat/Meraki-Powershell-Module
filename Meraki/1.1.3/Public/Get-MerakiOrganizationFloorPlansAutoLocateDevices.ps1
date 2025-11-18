function Get-MerakiOrganizationFloorPlansAutoLocateDevices {
    <#
    .SYNOPSIS
    Retrieves a list of devices with their firmware upgrade status for a specified Meraki organization.

    .DESCRIPTION
    This function retrieves a list of devices with their firmware upgrade status for a specified Meraki organization using the Meraki Dashboard API. The authentication token and organization ID are required for this operation. Optional parameters include the number of entries per page, pagination tokens, and filters for network IDs, device serials, MAC addresses, firmware upgrade IDs, and firmware upgrade batch IDs.

    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki Dashboard API.

    .PARAMETER OrganizationID
    Specifies the ID of the Meraki organization. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .PARAMETER perPage
    Specifies the number of entries per page.

    .PARAMETER startingAfter
    Specifies the pagination token for the next page of results.

    .PARAMETER endingBefore
    Specifies the pagination token for the previous page of results.

    .PARAMETER networkIds
    Specifies an array of network IDs to filter the results.

    .PARAMETER FloorPlanIds
    Specifies an array of floor plan IDs to filter the results.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationFloorPlansAutoLocateDevices -AuthToken "12345" -OrgId "123456" -perPage 100 -FloorPlanIds @("Q2XX-XXXX-XXXX", "Q2XX-YYYY-YYYY")
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
        [array]$floorPlanIds = $null
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
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
            if ($floorPlanIds) {
                $queryParams['floorPlanIds[]'] = $floorPlanIds
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams

            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/floorPlans/autoLocate/devices?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}