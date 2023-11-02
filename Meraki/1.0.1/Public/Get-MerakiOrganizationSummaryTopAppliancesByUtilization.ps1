function Get-MerakiOrganizationSummaryTopAppliancesByUtilization {
    <#
    .SYNOPSIS
    Gets a list of the top appliances in the organization sorted by their average CPU usage percentage over the given time range.

    .DESCRIPTION
    This function retrieves a list of the top appliances in the organization, sorted by their average CPU usage percentage over the given time range. The list includes the device name, serial number, average CPU usage percentage, and the number of clients connected to each device.

    .PARAMETER AuthToken
    The Meraki Dashboard API token.

    .PARAMETER OrgId
    The organization ID. If not specified, the function retrieves the ID of the first organization to which the API key has access.

    .PARAMETER t0
    The beginning of the time range for the query. If not specified, the default is 24 hours ago.

    .PARAMETER t1
    The end of the time range for the query. If not specified, the default is now.

    .PARAMETER timespan
    The timespan for which the information will be fetched. If not specified, the default is 1 hour. Acceptable values are 1 hour (3600 seconds), 12 hours (43200 seconds), 1 day (86400 seconds), 1 week (604800 seconds), or 1 month (2592000 seconds).

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationSummaryTopAppliancesByUtilization -AuthToken '1234' -OrgId '5678' -t0 '2023-04-18T08:00:00Z' -t1 '2023-04-19T08:00:00Z'

    This example retrieves a list of the top appliances in the organization, sorted by their average CPU usage percentage between April 18th, 2023 8:00:00 AM UTC and April 19th, 2023 8:00:00 AM UTC.

    .NOTES
    For more information, see https://developer.cisco.com/meraki/api-v1/#!get-organization-summary-top-appliances-by-utilization.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$t0 = $null,
        [parameter(Mandatory=$false)]
        [string]$t1 = $null,
        [parameter(Mandatory=$false)]
        [int]$timespan = $null
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
            $queryString = New-MerakiQueryString -queryParams $queryParams
        
            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/summary/top/appliances/byUtilization?$queryString"
        
            $URI = [uri]::EscapeUriString($URL)
        
            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header
            return $response
        } catch {
            Write-Error $_
        }
    }
}