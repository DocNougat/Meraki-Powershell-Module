function Get-MerakiOrganizationApplianceUplinkStatuses {
    <#
    .SYNOPSIS
    Retrieves the uplink status for appliances in an organization.

    .DESCRIPTION
    This function retrieves the uplink status for appliances in an organization.

    .PARAMETER AuthToken
    The authorization token for the Meraki dashboard.

    .PARAMETER OrgId
    The ID of the organization to retrieve uplink statuses for. If not specified, the default organization associated with the AuthToken will be used.

    .PARAMETER perPage
    The number of uplink status records to return per page.

    .PARAMETER startingAfter
    Returns uplink statuses that occur after this entry.

    .PARAMETER endingBefore
    Returns uplink statuses that occur before this entry.

    .PARAMETER networkIds
    An array of network IDs to filter the returned uplink statuses.

    .PARAMETER serials
    An array of serial numbers to filter the returned uplink statuses.

    .PARAMETER iccids
    An array of SIM card ICCIDs to filter the returned uplink statuses.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceUplinkStatuses -AuthToken "1234" -OrgId "5678"

    Retrieves the uplink statuses for all appliances in organization 5678.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationApplianceUplinkStatuses -AuthToken "1234" -serials "ABC123","DEF456"

    Retrieves the uplink statuses for appliances with serial numbers "ABC123" and "DEF456".

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
            if ($timespan) {
                $queryParams['timespan'] = $timespan
            } else {
                if ($t0) {
                    $queryParams['t0'] = $t0
                }
                if ($t1) {
                    $queryParams['t1'] = $t1
                }
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
            if ($sortOrder) {
                $queryParams['sortOrder'] = $sortOrder
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
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/appliance/uplink/statuses?$queryString"
            $URI = [uri]::EscapeUriString($URL)
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}