function Get-MerakiOrganizationClientsBandwidthUsageHistory {
    <#
    .SYNOPSIS
    Gets the bandwidth usage history for clients in an organization.

    .DESCRIPTION
    Use this API endpoint to retrieve the bandwidth usage history for clients in an organization. The historical usage data is in kilobits per second.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER OrgId
    The ID of the organization to which the clients belong. If not specified, the function will use the ID of the first organization returned by Get-MerakiOrganizations.

    .PARAMETER t0
    The beginning of the timespan for which clients will be fetched. The format is YYYY-MM-DDTHH:MM:SSZ.

    .PARAMETER t1
    The end of the timespan for which clients will be fetched. The format is YYYY-MM-DDTHH:MM:SSZ.

    .PARAMETER timespan
    The timespan for which clients will be fetched, in seconds. If specified, t0 and t1 will be ignored.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationClientsBandwidthUsageHistory -AuthToken $AuthToken -OrgId $OrganizationID -t0 "2022-01-01T00:00:00Z" -t1 "2022-01-31T23:59:59Z"

    Gets the bandwidth usage history for clients in the specified organization between January 1, 2022 and January 31, 2022.

    .NOTES
    For more information, see the Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/#!get-organization-clients-bandwidth-usage-history
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

            $URL = "https://api.meraki.com/api/v1/organizations/$OrganizationID/clients/bandwidthUsageHistory?$queryString"

            $URI = [uri]::EscapeUriString($URL)

            $response = Invoke-RestMethod -Method Get -Uri $URI -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        }
        catch {
        Write-Host $_
        Throw $_
    }
    }
}