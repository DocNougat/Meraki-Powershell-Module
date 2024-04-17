function Set-MerakiOrganizationCameraRole {
    <#
    .SYNOPSIS
    Updates a camera role for a Meraki organization using the Meraki Dashboard API.
    
    .DESCRIPTION
    The Set-MerakiOrganizationCameraRole function allows you to update a camera role for a specified Meraki organization by providing the authentication token, organization ID, role ID, and a camera role configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER OrganizationId
    The ID of the Meraki organization for which you want to update the camera role.
    
    .PARAMETER RoleId
    The ID of the camera role that you want to update.
    
    .PARAMETER CameraRoleConfig
    A string containing the camera role configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $CameraRoleConfig = [PSCustomObject]@{
        name = "Security_Guard"
        appliedOnDevices = @(
            [PSCustomObject]@{
                tag = "reception-desk"
                id = ""
                permissionScopeId = "1"
            }
        )
        appliedOnNetworks = @(
            [PSCustomObject]@{
                tag = "building-a"
                id = ""
                permissionScopeId = "2"
            }
        )
        appliedOrgWide = @(
            [PSCustomObject]@{
                tag = "building-a"
                id = ""
                permissionScopeId = "2"
            }
        )
    }

    $CameraRoleConfig = $CameraRoleConfig | ConvertTo-Json -Compress

    Set-MerakiOrganizationCameraRole -AuthToken "your-api-token" -OrganizationId "1234567890" -RoleId "R_1234567890" -CameraRoleConfig $CameraRoleConfig

    This example updates a camera role for the Meraki organization with ID "1234567890".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
    [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$RoleId,
        [parameter(Mandatory=$true)]
        [string]$CameraRoleConfig
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/camera/roles/$RoleId"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $CameraRoleConfig
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}