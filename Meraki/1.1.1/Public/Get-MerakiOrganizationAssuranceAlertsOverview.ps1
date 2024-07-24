function Get-MerakiOrganizationAssuranceAlertsOverview {
    <#
    .SYNOPSIS
    Retrieves an overview of assurance alerts for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve an overview of assurance alerts for a specified organization by providing the authentication token, organization ID, and optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER NetworkId
    Optional parameter to filter alerts overview by network ids.

    .PARAMETER Severity
    Optional parameter to filter alerts overview by severity type.

    .PARAMETER Types
    Optional parameter to filter by alert type.

    .PARAMETER TsStart
    Optional parameter to filter by starting timestamp.

    .PARAMETER TsEnd
    Optional parameter to filter by end timestamp.

    .PARAMETER Serials
    Optional parameter to filter by primary device serial.

    .PARAMETER DeviceTypes
    Optional parameter to filter by device types.

    .PARAMETER DeviceTags
    Optional parameter to filter by device tags.

    .PARAMETER Active
    Optional parameter to filter by active alerts. Defaults to true.

    .PARAMETER Dismissed
    Optional parameter to filter by dismissed alerts. Defaults to false.

    .PARAMETER Resolved
    Optional parameter to filter by resolved alerts. Defaults to false.

    .PARAMETER SuppressAlertsForOfflineNodes
    When set to true, the API will only return connectivity alerts for a given device if that device is in an offline state. Defaults to false.

    .EXAMPLE
    Get-MerakiOrganizationAssuranceAlertsOverview -AuthToken "your-api-token" -OrganizationId "123456" -Severity "critical" -Active $true

    This example retrieves an overview of critical active assurance alerts for the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$false)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [string]$Severity,
        [parameter(Mandatory=$false)]
        [string[]]$Types,
        [parameter(Mandatory=$false)]
        [string]$TsStart,
        [parameter(Mandatory=$false)]
        [string]$TsEnd,
        [parameter(Mandatory=$false)]
        [string[]]$Serials,
        [parameter(Mandatory=$false)]
        [string[]]$DeviceTypes,
        [parameter(Mandatory=$false)]
        [string[]]$DeviceTags,
        [parameter(Mandatory=$false)]
        [bool]$Active = $true,
        [parameter(Mandatory=$false)]
        [bool]$Dismissed = $false,
        [parameter(Mandatory=$false)]
        [bool]$Resolved = $false,
        [parameter(Mandatory=$false)]
        [bool]$SuppressAlertsForOfflineNodes = $false
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
                active = $Active
                dismissed = $Dismissed
                resolved = $Resolved
                suppressAlertsForOfflineNodes = $SuppressAlertsForOfflineNodes
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

            if ($TsStart) {
                $queryParams['tsStart'] = $TsStart
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

            if ($DeviceTags) {
                $queryParams['deviceTags'] = ($DeviceTags -join ",")
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/assurance/alerts/overview?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}