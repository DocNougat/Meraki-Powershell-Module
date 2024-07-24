function Get-MerakiOrganizationInventoryDevicesSwapsBulk {
    <#
    .SYNOPSIS
    Retrieves details of a bulk device swap for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve the details of a bulk device swap for a specified organization by providing the authentication token, organization ID, and the swap ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER SwapId
    The ID of the bulk device swap.

    .EXAMPLE
    Get-MerakiOrganizationInventoryDevicesSwapsBulk -AuthToken "your-api-token" -OrganizationId "123456" -SwapId "swapId123"

    This example retrieves the details of the bulk device swap with ID "swapId123" for the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$OrganizationId,
        [parameter(Mandatory=$true)]
        [string]$SwapId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/inventory/devices/swaps/bulk/$SwapId"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
