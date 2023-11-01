function Get-MerakiOrganizationCameraRole {
    <#
    .SYNOPSIS
    Retrieves a specific camera role for a Meraki organization.
    
    .DESCRIPTION
    This function retrieves a specific camera role for a Meraki organization using the Meraki Dashboard API. It requires an authentication token for the API and the ID of the organization and role ID for which the role should be retrieved.
    
    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.
    
    .PARAMETER OrganizationID
    The ID of the organization for which the camera role should be retrieved.
    
    .PARAMETER RoleId
    The ID of the camera role that you want to retrieve.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationCameraRole -AuthToken $AuthToken -OrganizationID $OrganizationID -RoleId $RoleId
    
    Retrieves a specific camera role for the specified organization.
    
    .NOTES
    This function requires the Get-MerakiOrganizations function.
    
    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-camera-roles
    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$OrganizationID,
            [parameter(Mandatory=$true)]
            [string]$RoleId
        )
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/camera/roles/$RoleId" -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }