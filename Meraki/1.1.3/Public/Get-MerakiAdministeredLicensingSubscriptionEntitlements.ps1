function Get-MerakiAdministeredLicensingSubscriptionEntitlements {
    <#
    .SYNOPSIS
    Retrieves administered licensing subscription entitlements.

    .DESCRIPTION
    This function allows you to retrieve administered licensing subscription entitlements by providing the authentication token and an optional list of SKUs.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Skus
    A list of SKUs to filter entitlements.

    .EXAMPLE
    Get-MerakiAdministeredLicensingSubscriptionEntitlements -AuthToken "your-api-token" -Skus @("SKU1234", "SKU5678")

    This example retrieves administered licensing subscription entitlements filtered by the specified SKUs.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string[]]$Skus
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $queryParams = @{}

        if ($Skus) {
            $queryParams['skus'] = $Skus -join ","
        }

        $queryString = New-MerakiQueryString -queryParams $queryParams

        $url = "https://api.meraki.com/api/v1/administered/licensing/subscription/entitlements?$queryString"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
