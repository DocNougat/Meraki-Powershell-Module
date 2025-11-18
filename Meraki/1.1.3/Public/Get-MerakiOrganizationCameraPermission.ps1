function Get-MerakiOrganizationCameraPermission {
    <#
    .SYNOPSIS
    Retrieves the details of a specific camera permission for a specified organization.

    .DESCRIPTION
    This function allows you to retrieve the details of a specific camera permission for a specified organization by providing the authentication token, organization ID, and the permission scope ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER PermissionScopeId
    The ID of the permission scope.

    .EXAMPLE
    Get-MerakiOrganizationCameraPermission -AuthToken "your-api-token" -OrganizationId "123456" -PermissionScopeId "scopeId123"

    This example retrieves the details of the camera permission with scope ID "scopeId123" for the organization with ID "123456".

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
        [string]$PermissionScopeId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
        } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/permissions/$PermissionScopeId"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}