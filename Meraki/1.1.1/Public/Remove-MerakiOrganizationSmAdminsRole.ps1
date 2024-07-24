function Remove-MerakiOrganizationSmAdminsRole {
    <#
    .SYNOPSIS
    Removes a specific Limited Access Role for administrators in an organization.

    .DESCRIPTION
    This function allows you to remove a specific Limited Access Role for administrators in a given organization by providing the authentication token, organization ID, and role ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER RoleId
    The ID of the Limited Access Role to remove.

    .EXAMPLE
    Remove-MerakiOrganizationSmAdminsRole -AuthToken "your-api-token" -OrganizationId "123456" -RoleId "roleId1"

    This example removes the Limited Access Role with ID "roleId1" in the organization with ID "123456".

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
        [string]$RoleId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/sm/admins/roles/$RoleId"

        $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
