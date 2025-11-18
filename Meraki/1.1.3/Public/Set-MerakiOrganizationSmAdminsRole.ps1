function Set-MerakiOrganizationSmAdminsRole {
    <#
    .SYNOPSIS
    Updates a specific Limited Access Role for administrators in an organization.

    .DESCRIPTION
    This function allows you to update a specific Limited Access Role for administrators in a given organization by providing the authentication token, organization ID, role ID, and the role details including name, scope, and tags.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER RoleId
    The ID of the Limited Access Role to update.

    .PARAMETER Name
    The name of the Limited Access Role.

    .PARAMETER Scope
    The scope of the Limited Access Role. Possible values are all_tags, some, without_all_tags, without_some.

    .PARAMETER Tags
    The tags of the Limited Access Role.

    .EXAMPLE
    $Tags = @("tag1", "tag2")
    Set-MerakiOrganizationSmAdminsRole -AuthToken "your-api-token" -OrganizationId "123456" -RoleId "roleId1" -Name "UpdatedRole" -Scope "some" -Tags $Tags

    This example updates the Limited Access Role with ID "roleId1" in the organization with ID "123456", setting the name to "UpdatedRole", scope to "some", and tags to ["tag1", "tag2"].

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
        [string]$RoleId,
        [parameter(Mandatory=$false)]
        [string]$Name,
        [parameter(Mandatory=$false)]
        [string]$Scope,
        [parameter(Mandatory=$false)]
        [string[]]$Tags
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $body = @{}

            if ($Name) {
                $body.name = $Name
            }

            if ($Scope) {
                $body.scope = $Scope
            }

            if ($Tags) {
                $body.tags = $Tags
            }

            $bodyJson = $body | ConvertTo-Json -Compress

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/sm/admins/roles/$RoleId"

            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $bodyJson
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}