function Get-MerakiOrganizationSmAdminsRole {
    <#
    .SYNOPSIS
    Retrieves details of a specific Limited Access Role for administrators in an organization.

    .DESCRIPTION
    This function allows you to retrieve details of a specific Limited Access Role for administrators in a given organization by providing the authentication token, organization ID, and role ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER RoleId
    The ID of the Limited Access Role to retrieve.

    .EXAMPLE
    Get-MerakiOrganizationSmAdminsRole -AuthToken "your-api-token" -OrganizationId "123456" -RoleId "roleId1"

    This example retrieves details of the Limited Access Role with ID "roleId1" in the organization with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationId = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$RoleId
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/sm/admins/roles/$RoleId"

            $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}