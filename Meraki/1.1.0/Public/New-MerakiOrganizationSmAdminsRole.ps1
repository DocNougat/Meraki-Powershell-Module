function New-MerakiOrganizationSmAdminsRole {
    <#
    .SYNOPSIS
    Creates a new Limited Access Role for administrators in an organization.

    .DESCRIPTION
    This function allows you to create a new Limited Access Role for administrators in a given organization by providing the authentication token, organization ID, and the role details including name, scope, and tags.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER OrganizationId
    The ID of the organization.

    .PARAMETER Name
    The name of the Limited Access Role.

    .PARAMETER Scope
    The scope of the Limited Access Role. Possible values are all_tags, some, without_all_tags, without_some.

    .PARAMETER Tags
    The tags of the Limited Access Role.

    .EXAMPLE
    $Tags = @("tag1", "tag2")
    New-MerakiOrganizationSmAdminsRole -AuthToken "your-api-token" -OrganizationId "123456" -Name "NewRole" -Scope "some" -Tags $Tags

    This example creates a new Limited Access Role named "NewRole" with scope "some" and tags ["tag1", "tag2"] in the organization with ID "123456".

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
        [string]$Name,
        [parameter(Mandatory=$false)]
        [string]$Scope,
        [parameter(Mandatory=$false)]
        [string[]]$Tags
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            name = $Name
        }

        if ($Scope) {
            $body.scope = $Scope
        }

        if ($Tags) {
            $body.tags = $Tags
        }

        $bodyJson = $body | ConvertTo-Json -Compress

        $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/sm/admins/roles"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
