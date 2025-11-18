function Get-MerakiOrganizationAssuranceAlertsOverviewHistorical {
    <#
    .SYNOPSIS
    Retrieves a historical overview of assurance alerts for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve a historical overview of assurance alerts for a specified organization by providing the authentication token, organization ID, segment duration, start timestamp, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER SegmentDuration
    The amount of time in seconds for each segment in the returned dataset.

    .PARAMETER TsStart
    The starting timestamp of historical totals.

    .PARAMETER NetworkId
    Optional parameter to filter alerts overview by network ids.

    .PARAMETER Severity
    Optional parameter to filter alerts overview by severity type.

    .PARAMETER Types
    Optional parameter to filter by alert type.

    .PARAMETER TsEnd
    Optional parameter to filter by end timestamp defaults to the current time.

    .PARAMETER Serials
    Optional parameter to filter by primary device serial.

    .PARAMETER DeviceTypes
    Optional parameter to filter by device types.

    .EXAMPLE
    Get-MerakiOrganizationAssuranceAlertsOverviewHistorical -AuthToken "your-api-token" -OrganizationId "123456" -SegmentDuration 3600 -TsStart "2022-01-01T00:00:00Z"

    This example retrieves a historical overview of assurance alerts for the organization with ID "123456" with segment duration of 3600 seconds starting from "2022-01-01T00:00:00Z".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [int]$SegmentDuration,
        [parameter(Mandatory=$true)]
        [string]$TsStart,
        [parameter(Mandatory=$false)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [string]$Severity,
        [parameter(Mandatory=$false)]
        [string[]]$Types,
        [parameter(Mandatory=$false)]
        [string]$TsEnd,
        [parameter(Mandatory=$false)]
        [string[]]$Serials,
        [parameter(Mandatory=$false)]
        [string[]]$DeviceTypes
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $queryParams = @{
                segmentDuration = $SegmentDuration
                tsStart = $TsStart
            }

            if ($NetworkId) {
                $queryParams['networkId'] = $NetworkId
            }

            if ($Severity) {
                $queryParams['severity'] = $Severity
            }

            if ($Types) {
                $queryParams['types'] = ($Types -join ",")
            }

            if ($TsEnd) {
                $queryParams['tsEnd'] = $TsEnd
            }

            if ($Serials) {
                $queryParams['serials'] = ($Serials -join ",")
            }

            if ($DeviceTypes) {
                $queryParams['deviceTypes'] = ($DeviceTypes -join ",")
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/assurance/alerts/overview/historical?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}