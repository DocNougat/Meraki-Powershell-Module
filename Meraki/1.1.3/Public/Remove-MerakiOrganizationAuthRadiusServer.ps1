function Remove-MerakiOrganizationAuthRadiusServer {
    <#
    .SYNOPSIS
    Removes a RADIUS authentication server from a Cisco Meraki organization.

    .DESCRIPTION
    Deletes an existing RADIUS server configuration from the specified Meraki organization by calling the Meraki Dashboard API DELETE endpoint:
    https://api.meraki.com/api/v1/organizations/{organizationId}/auth/radius/servers/{serverId}

    If OrganizationID is not provided, the function attempts to resolve it by calling Get-OrgID -AuthToken <token>. If multiple organizations are found, the function returns the message "Multiple organizations found. Please specify an organization ID." and will not perform the delete.

    .PARAMETER AuthToken
    The Meraki Dashboard API key to authenticate the request (sent as X-Cisco-Meraki-API-Key). This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID. If omitted, the function attempts to determine the organization via Get-OrgID -AuthToken. If multiple organizations are detected, specify this parameter explicitly.

    .PARAMETER ServerID
    The identifier of the RADIUS server to remove. This parameter is mandatory.

    .EXAMPLE
    # Provide an explicit organization and server ID
    Remove-MerakiOrganizationAuthRadiusServer -AuthToken 'ABCDEF1234567890' -OrganizationID '123456' -ServerID '7890'

    .EXAMPLE
    # Let the function resolve the organization automatically (when a single org exists)
    Remove-MerakiOrganizationAuthRadiusServer -AuthToken 'ABCDEF1234567890' -ServerID '7890'

    .NOTES
    - Early API Access must be enabled on the target organization to use this endpoint.
    - Requires network access to api.meraki.com.
    - The provided API key must have write permission for the target organization.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken),
        [parameter(Mandatory=$true)]
        [string]$ServerID
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/auth/radius/servers/$ServerID"

            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}