function Get-MerakiOrganizationCameraCustomAnalyticsArtifacts {
    <#
    .SYNOPSIS
    Retrieves custom analytics artifacts for a Meraki organization's camera.

    .DESCRIPTION
    This function retrieves custom analytics artifacts for a Meraki organization's camera using the Meraki Dashboard API. It requires an authentication token for the API and the ID of the organization for which the artifacts should be retrieved.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrganizationID
    The ID of the organization for which the custom analytics artifacts should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationCameraCustomAnalyticsArtifacts -AuthToken $AuthToken OrganizationID $OrganizationID

    Retrieves custom analytics artifacts for the specified organization's camera.

    .NOTES
    This function requires the Get-MerakiOrganizations function.

    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-camera-custom-analytics-artifacts
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/camera/customAnalytics/artifacts" -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}
