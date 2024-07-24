function Get-MerakiOrganizationSwitchPortsOverview {
    <#
    .SYNOPSIS
    Retrieves an overview of switch ports for an organization.

    .DESCRIPTION
    This function allows you to retrieve an overview of switch ports for a given organization by providing the authentication token, organization ID, and optional query parameters for timespan or specific time range.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER t0
    The beginning of the timespan for the data.

    .PARAMETER t1
    The end of the timespan for the data. t1 can be a maximum of 186 days after t0.

    .PARAMETER Timespan
    The timespan for which the information will be fetched. If specifying timespan, do not specify parameters t0 and t1. The value must be in seconds and be greater than or equal to 12 hours and be less than or equal to 186 days. The default is 1 day.

    .EXAMPLE
    Get-MerakiOrganizationSwitchPortsOverview -AuthToken "your-api-token" -OrganizationId "123456" -Timespan 86400

    This example retrieves the switch ports overview for the organization with ID "123456" for the past 24 hours.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$t0,
        [parameter(Mandatory=$false)]
        [string]$t1,
        [parameter(Mandatory=$false)]
        [int]$Timespan
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $queryParams = @{}

            if ($t0) {
                $queryParams['t0'] = $t0
            }

            if ($t1) {
                $queryParams['t1'] = $t1
            }

            if ($Timespan) {
                $queryParams['timespan'] = $Timespan
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/switch/ports/overview?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}