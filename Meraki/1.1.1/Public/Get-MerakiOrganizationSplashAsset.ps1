function Get-MerakiOrganizationSplashAsset {
    <#
    .SYNOPSIS
    Retrieves a splash asset for an organization.

    .DESCRIPTION
    This function allows you to retrieve a splash asset for an organization by providing the authentication token, organization ID, and asset ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER AssetId
    The ID of the splash asset.

    .EXAMPLE
    Get-MerakiOrganizationSplashAsset -AuthToken "your-api-token" -OrganizationId "123456" -AssetId "asset_id"

    This example retrieves the splash asset with ID "asset_id" for the organization with ID "123456".

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
        [string]$AssetId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/splash/assets/$AssetId"

            $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}