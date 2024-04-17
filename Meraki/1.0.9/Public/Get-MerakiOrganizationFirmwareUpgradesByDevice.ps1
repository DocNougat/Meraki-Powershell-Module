function Get-MerakiOrganizationFirmwareUpgradesByDevice {
    <#
    .SYNOPSIS
    Retrieves a list of devices with their firmware upgrade status for a specified Meraki organization.

    .DESCRIPTION
    This function retrieves a list of devices with their firmware upgrade status for a specified Meraki organization using the Meraki Dashboard API. The authentication token and organization ID are required for this operation. Optional parameters include the number of entries per page, pagination tokens, and filters for network IDs, device serials, MAC addresses, firmware upgrade IDs, and firmware upgrade batch IDs.

    .PARAMETER AuthToken
    Specifies the authentication token for the Meraki Dashboard API.

    .PARAMETER OrgId
    Specifies the ID of the Meraki organization. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .PARAMETER perPage
    Specifies the number of entries per page.

    .PARAMETER startingAfter
    Specifies the pagination token for the next page of results.

    .PARAMETER endingBefore
    Specifies the pagination token for the previous page of results.

    .PARAMETER networkIds
    Specifies an array of network IDs to filter the results.

    .PARAMETER serials
    Specifies an array of device serials to filter the results.

    .PARAMETER macs
    Specifies an array of device MAC addresses to filter the results.

    .PARAMETER firmwareUpgradeIds
    Specifies an array of firmware upgrade IDs to filter the results.

    .PARAMETER firmwareUpgradeBatchIds
    Specifies an array of firmware upgrade batch IDs to filter the results.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationFirmwareUpgradesByDevice -AuthToken "12345" -OrgId "123456" -perPage 100 -serials "Q2XX-XXXX-XXXX"

    Retrieves a list of devices with firmware upgrade status for the organization with ID "123456" using the authentication token "12345". The results are filtered by device serial number "Q2XX-XXXX-XXXX" and there are 100 results per page.
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
        [array]$serials = $null,
        [parameter(Mandatory=$false)]
        [array]$macs = $null,
        [parameter(Mandatory=$false)]
        [array]$firmwareUpgradeIds = $null,
        [parameter(Mandatory=$false)]
        [array]$firmwareUpgradeBatchIds = $null
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
            if ($serials) {
                $queryParams['serials[]'] = $serials
            }
            if ($macs) {
                $queryParams['macs[]'] = $macs
            }
            if ($firmwareUpgradeIds) {
                $queryParams['firmwareUpgradeIds[]'] = $firmwareUpgradeIds
            }
            if ($firmwareUpgradeBatchIds) {
                $queryParams['firmwareUpgradeBatchIds[]'] = $firmwareUpgradeBatchIds
            }
        
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/firmware/upgrades/byDevice?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}