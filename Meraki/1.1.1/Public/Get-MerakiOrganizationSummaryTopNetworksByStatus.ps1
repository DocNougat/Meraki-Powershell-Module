function Get-MerakiOrganizationSummaryTopNetworksByStatus {
    <#
    .SYNOPSIS
    Retrieves the top networks by status for an organization.

    .DESCRIPTION
    This function allows you to retrieve the top networks by status for an organization by providing the authentication token, organization ID, and optional query parameters for filtering and pagination.

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

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 5000.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page. Often this is a timestamp or an ID but it is not limited to those.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page. Often this is a timestamp or an ID but it is not limited to those.

    .EXAMPLE
    Get-MerakiOrganizationSummaryTopNetworksByStatus -AuthToken "your-api-token" -OrganizationId "123456" -Quantity 20

    This example retrieves the top 20 networks by status for the organization with ID "123456".

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
        [int]$PerPage,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore
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

            if ($PerPage) {
                $queryParams['perPage'] = $PerPage
            }

            if ($StartingAfter) {
                $queryParams['startingAfter'] = $StartingAfter
            }

            if ($EndingBefore) {
                $queryParams['endingBefore'] = $EndingBefore
            }

            $queryString = New-MerakiQueryString -queryParams $queryParams
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/summary/top/networks/byStatus?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}