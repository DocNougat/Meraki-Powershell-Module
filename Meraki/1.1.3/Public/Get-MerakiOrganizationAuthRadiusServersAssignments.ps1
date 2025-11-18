function Get-MerakiOrganizationAuthRadiusServersAssignments {
    <#
    .SYNOPSIS
    Retrieves the RADIUS authentication server assignments for a Meraki organization.

    .DESCRIPTION
    Calls the Cisco Meraki API to return the authentication RADIUS server assignments for the specified organization.
    Provide a valid Meraki API key via -AuthToken. If -OrganizationID is omitted, the function attempts to determine the organization ID
    by calling Get-OrgID -AuthToken <token>. If multiple organizations are found, the caller must explicitly supply -OrganizationID.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID to query. If omitted, the function attempts to auto-discover a single organization using Get-OrgID.
    If multiple organizations are returned by Get-OrgID, you must specify this parameter.
    
    .EXAMPLE
    # Using an explicit organization ID
    Get-MerakiOrganizationAuthRadiusServersAssignments -AuthToken 'ABCDEF123456' -OrganizationID '123456'

    .EXAMPLE
    # Let the helper determine the organization ID (only works when a single org is found)
    Get-MerakiOrganizationAuthRadiusServersAssignments -AuthToken 'ABCDEF123456'

    .NOTES
    - Early API Access must be enabled on the target organization to use this endpoint.
    - Requires network access to api.meraki.com.
    - The provided API key must have read permission for the target organization.

    .LINK
    https://developer.cisco.com/meraki/api-v1/  # Meraki API documentation
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/auth/radius/servers/assignments" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }
}
