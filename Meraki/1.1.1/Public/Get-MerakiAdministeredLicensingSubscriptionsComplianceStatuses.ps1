function Get-MerakiAdministeredLicensingSubscriptionsComplianceStatuses {
    <#
    .SYNOPSIS
    Retrieves subscription compliance statuses for administered licensing subscriptions.

    .DESCRIPTION
    This function allows you to retrieve subscription compliance statuses for administered licensing subscriptions by providing the authentication token, organization IDs, and optional subscription IDs.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationIds
    An array of organization IDs to get subscription compliance information for.

    .PARAMETER SubscriptionIds
    An optional array of subscription IDs.

    .EXAMPLE
    $organizationIds = @("orgId1", "orgId2")
    $subscriptionIds = @("subId1", "subId2")
    Get-MerakiAdministeredLicensingSubscriptionsComplianceStatuses -AuthToken "your-api-token" -OrganizationIds $organizationIds -SubscriptionIds $subscriptionIds

    This example retrieves subscription compliance statuses for the specified organization IDs and subscription IDs.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string[]]$SubscriptionIds
    )
    $OrganizationIDs = (Get-OrgID -AuthToken $AuthToken)
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $queryParams = @{
            organizationIds = ($OrganizationIds -join ",")
        }

        if ($SubscriptionIds) {
            $queryParams['subscriptionIds'] = ($SubscriptionIds -join ",")
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams
        $url = "https://api.meraki.com/api/v1/administered/licensing/subscription/subscriptions/compliance/statuses?$queryString"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
