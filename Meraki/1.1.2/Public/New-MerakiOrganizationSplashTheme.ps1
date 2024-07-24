function New-MerakiOrganizationSplashTheme {
    <#
    .SYNOPSIS
    Creates a new splash theme for the specified organization.

    .DESCRIPTION
    This function allows you to create a new splash theme for a specified organization by providing the authentication token, organization ID, and optional JSON schema parameters.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER BaseTheme
    The base theme ID.

    .PARAMETER Name
    The theme name.

    .EXAMPLE
    New-MerakiOrganizationSplashTheme -AuthToken "your-api-token" -OrganizationId "123456" -BaseTheme "base_theme_id" -Name "New Theme"

    This example creates a new splash theme named "New Theme" with the base theme ID "base_theme_id" for the organization with ID "123456".

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
        [string]$BaseTheme,
        [parameter(Mandatory=$false)]
        [string]$Name
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = [PSCustomObject]@{}

            if ($BaseTheme) {
                $body.baseTheme = $BaseTheme
            }

            if ($Name) {
                $body.name = $Name
            }

            $jsonBody = $body | ConvertTo-Json -Depth 4
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/splash/themes"

            $response = Invoke-RestMethod -Method Post -Uri $url -Headers $header -Body $jsonBody -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}