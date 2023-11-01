function Get-MerakiOrganizationCameraRoles {
    <#
    .SYNOPSIS
    Retrieves camera roles for a Meraki organization.
    
    .DESCRIPTION
    This function retrieves camera roles for a Meraki organization using the Meraki Dashboard API. It requires an authentication token for the API and the ID of the organization for which the roles should be retrieved.
    
    .PARAMETER AuthToken
    The authentication token for the Meraki Dashboard API.
    
    .PARAMETER OrganizationID
    The ID of the organization for which the camera roles should be retrieved. If not specified, the function will use the ID of the first organization returned by the Get-MerakiOrganizations function.
    
    .EXAMPLE
    PS C:\> Get-MerakiOrganizationCameraRoles -AuthToken $AuthToken -OrganizationID $OrganizationID
    
    Retrieves camera roles for the specified organization.
    
    .NOTES
    This function requires the Get-MerakiOrganizations function.
    
    .LINK
    https://developer.cisco.com/meraki/api-v1/#!get-organization-camera-roles
    #>
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$false)]
            [string]$OrganizationID = (Get-MerakiOrganizations -AuthToken $AuthToken).id
        )
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/camera/roles" -Header $header
            return $response
        }
        catch {
            Write-Error $_
        }
    }