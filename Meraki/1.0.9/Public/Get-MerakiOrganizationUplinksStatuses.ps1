function Get-MerakiOrganizationUplinksStatuses {
    <#
    .SYNOPSIS
    Retrieves the uplink statuses for all the devices in an organization.

    .DESCRIPTION
    The Get-MerakiOrganizationUplinksStatuses function retrieves the uplink statuses for all the devices in the specified Meraki organization. You can optionally filter the results by network, device serial number, or SIM card ICCID. 

    .PARAMETER AuthToken
    The API token to use for authentication. This parameter is mandatory.

    .PARAMETER OrgId
    The ID of the organization for which to retrieve the uplink statuses. If not specified, the function retrieves the uplink statuses for the first organization in the list of organizations for which the user has privileges.

    .PARAMETER perPage
    The number of entries per page to return. If not specified, the function returns all the entries in a single page.

    .PARAMETER startingAfter
    A pagination parameter that specifies the starting point for the next page of results. If not specified, the function starts at the first page.

    .PARAMETER endingBefore
    A pagination parameter that specifies the ending point for the previous page of results. If not specified, the function ends at the last page.

    .PARAMETER networkIds
    An array of network IDs to use as a filter. If not specified, the function retrieves the uplink statuses for all the networks in the organization.

    .PARAMETER serials
    An array of device serial numbers to use as a filter. If not specified, the function retrieves the uplink statuses for all the devices in the organization.

    .PARAMETER iccids
    An array of SIM card ICCIDs to use as a filter. If not specified, the function retrieves the uplink statuses for all the SIM cards in the organization.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationUplinksStatuses -AuthToken "my_api_key" -OrgId "12345" -networkIds "NW_1234","NW_5678" -serials "Q2XX-XXXX-XXXX","Q2YY-YYYY-YYYY"

    Retrieves the uplink statuses for the specified networks and devices in the organization.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationUplinksStatuses -AuthToken "my_api_key" -OrgId "12345" -iccids "898XXXXXXX5XXXXXXX1","898XXXXXXX5XXXXXXX2"

    Retrieves the uplink statuses for the specified SIM cards in the organization.

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
        [array]$iccids = $null
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
            if ($iccids) {
                $queryParams['iccids[]'] = $iccids
            }
            
            $queryString = New-MerakiQueryString -queryParams $queryParams
            $URI = "https://api.meraki.com/api/v1/organizations/$OrganizationID/uplinks/statuses?$queryString"
            $response = Invoke-RestMethod -Method Get -Uri $URI -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}