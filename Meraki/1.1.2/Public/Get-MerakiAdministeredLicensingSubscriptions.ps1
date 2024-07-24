function Get-MerakiAdministeredLicensingSubscriptions {
    <#
    .SYNOPSIS
    Retrieves administered licensing subscriptions.

    .DESCRIPTION
    This function allows you to retrieve administered licensing subscriptions by providing the authentication token and various optional query parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER PerPage
    The number of entries per page returned. Acceptable range is 3 - 1000. Default is 1000.

    .PARAMETER StartingAfter
    A token used by the server to indicate the start of the page. Should not be defined by client applications.

    .PARAMETER EndingBefore
    A token used by the server to indicate the end of the page. Should not be defined by client applications.

    .PARAMETER SubscriptionIds
    List of subscription IDs to fetch.

    .PARAMETER OrganizationIds
    List of organization IDs to get associated subscriptions for.

    .PARAMETER Statuses
    List of statuses that returned subscriptions can have. Valid values: "active", "canceled", "expired", "inactive".

    .PARAMETER ProductTypes
    List of product types that returned subscriptions need to have entitlements for. Valid values: "appliance", "camera", "cellularGateway", "secureConnect", "sensor", "switch", "systemsManager", "wireless", "wirelessController".

    .PARAMETER StartDate
    Filter subscriptions by start date, ISO 8601 format. Accepted options: lt, gt, lte, gte, neq.

    .PARAMETER EndDate
    Filter subscriptions by end date, ISO 8601 format. Accepted options: lt, gt, lte, gte, neq.

    .EXAMPLE
    Get-MerakiAdministeredLicensingSubscriptions -AuthToken "your-api-token" -PerPage 500 -Statuses @("active", "inactive")

    This example retrieves administered licensing subscriptions with a limit of 500 entries per page and statuses "active" and "inactive".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [int]$PerPage = 1000,
        [parameter(Mandatory=$false)]
        [string]$StartingAfter,
        [parameter(Mandatory=$false)]
        [string]$EndingBefore,
        [parameter(Mandatory=$false)]
        [string[]]$SubscriptionIds,
        [parameter(Mandatory=$false)]
        [string[]]$OrganizationIds,
        [parameter(Mandatory=$false)]
        [ValidateSet("active", "canceled", "expired", "inactive")]
        [string[]]$Statuses,
        [parameter(Mandatory=$false)]
        [ValidateSet("appliance", "camera", "cellularGateway", "secureConnect", "sensor", "switch", "systemsManager", "wireless", "wirelessController")]
        [string[]]$ProductTypes,
        [parameter(Mandatory=$false)]
        [object]$StartDate,
        [parameter(Mandatory=$false)]
        [object]$EndDate
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json"
        }

        $queryParams = @{}

        if ($PerPage) {
            $queryParams['perPage'] = $PerPage
        }

        if ($StartingAfter) {
            $queryParams['startingAfter'] = $StartingAfter
        }

        if ($EndingBefore) {
            $queryParams['endingBefore'] = $EndingBefore
        }

        if ($SubscriptionIds) {
            $queryParams['subscriptionIds'] = $SubscriptionIds -join ","
        }

        if ($OrganizationIds) {
            $queryParams['organizationIds'] = $OrganizationIds -join ","
        }

        if ($Statuses) {
            $queryParams['statuses'] = $Statuses -join ","
        }

        if ($ProductTypes) {
            $queryParams['productTypes'] = $ProductTypes -join ","
        }

        if ($StartDate) {
            $queryParams['startDate'] = $StartDate
        }

        if ($EndDate) {
            $queryParams['endDate'] = $EndDate
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $url = "https://api.meraki.com/api/v1/administered/licensing/subscription/subscriptions?$queryString"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
