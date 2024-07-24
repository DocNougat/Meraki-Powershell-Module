function Get-MerakiOrganizationSummaryTopApplicationsByUsage {
    <#
    .SYNOPSIS
    Retrieves the top applications by usage for an organization.

    .DESCRIPTION
    This function allows you to retrieve the top applications by usage for an organization by providing the authentication token, organization ID, and optional query parameters for filtering and pagination.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER NetworkTag
    Match result to an exact network tag.

    .PARAMETER DeviceTag
    Match result to an exact device tag.

    .PARAMETER NetworkId
    Match result to an exact network ID.

    .PARAMETER Quantity
    Set number of desired results to return. Default is 10.

    .PARAMETER SsidName
    Filter results by SSID name.

    .PARAMETER UsageUplink
    Filter results by usage uplink.

    .PARAMETER T0
    The beginning of the timespan for the data.

    .PARAMETER T1
    The end of the timespan for the data. t1 can be a maximum of 186 days after t0.

    .PARAMETER Timespan
    The timespan for which the information will be fetched. If specifying timespan, do not specify parameters t0 and t1. The value must be in seconds and be greater than or equal to 25 minutes and be less than or equal to 186 days. The default is 1 day.

    .EXAMPLE
    Get-MerakiOrganizationSummaryTopApplicationsByUsage -AuthToken "your-api-token" -OrganizationId "123456" -Quantity 20

    This example retrieves the top 20 applications by usage for the organization with ID "123456".

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
        [string]$NetworkTag,
        [parameter(Mandatory=$false)]
        [string]$DeviceTag,
        [parameter(Mandatory=$false)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [int]$Quantity = 10,
        [parameter(Mandatory=$false)]
        [string]$SsidName,
        [parameter(Mandatory=$false)]
        [string]$UsageUplink,
        [parameter(Mandatory=$false)]
        [string]$T0,
        [parameter(Mandatory=$false)]
        [string]$T1,
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

            if ($NetworkTag) {
                $queryParams['networkTag'] = $NetworkTag
            }

            if ($DeviceTag) {
                $queryParams['deviceTag'] = $DeviceTag
            }

            if ($NetworkId) {
                $queryParams['networkId'] = $NetworkId
            }

            if ($Quantity) {
                $queryParams['quantity'] = $Quantity
            }

            if ($SsidName) {
                $queryParams['ssidName'] = $SsidName
            }

            if ($UsageUplink) {
                $queryParams['usageUplink'] = $UsageUplink
            }

            if ($T0) {
                $queryParams['t0'] = $T0
            }

            if ($T1) {
                $queryParams['t1'] = $T1
            }

            if ($Timespan) {
                $queryParams['timespan'] = $Timespan
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/summary/top/applications/byUsage?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}