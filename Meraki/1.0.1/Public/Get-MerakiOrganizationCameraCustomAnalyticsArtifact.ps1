function Get-MerakiOrganizationCameraCustomAnalyticsArtifact {
    <#
    .SYNOPSIS
    Retrieves a custom analytics artifact for a Meraki organization's camera.

    .DESCRIPTION
    This function retrieves a custom analytics artifact for a Meraki organization's camera using the Meraki Dashboard API. It requires an authentication token for the API, the ID of the organization to which the camera belongs, and the ID of the artifact to be retrieved.

    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.

    .PARAMETER OrgID
    The ID of the organization to which the camera belongs. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.

    .PARAMETER artifactId
    The ID of the custom analytics artifact to be retrieved.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationCameraCustomAnalyticsArtifact -AuthToken $AuthToken -OrgID $OrganizationID -artifactId $artifactId

    Retrieves the specified custom analytics artifact for the specified organization's camera.

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
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$artifactId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/camera/customAnalytics/artifacts/$artifactId" -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }
}
