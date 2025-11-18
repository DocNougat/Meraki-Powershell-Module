function Remove-MerakiOrganizationSpacesIntegration {
    <#
    .SYNOPSIS
    Removes the Meraki Spaces integration for a specified Meraki organization.

    .DESCRIPTION
    Remove-MerakiOrganizationSpacesIntegration sends a POST request to the Meraki Dashboard API endpoint
    /organizations/{organizationId}/spaces/integration/remove to remove the Spaces integration for the given
    organization. An API key (AuthToken) is required. If OrganizationID is not provided, the function attempts
    to resolve the organization ID by calling Get-OrgID -AuthToken $AuthToken. If Get-OrgID reports multiple
    organizations, the function will return the message "Multiple organizations found. Please specify an organization ID."
    and will not attempt the API call.

    .PARAMETER AuthToken
    The Meraki API key used to authenticate the request. This parameter is mandatory.

    .PARAMETER OrganizationID
    The Meraki organization ID for which the Spaces integration should be removed. If omitted, the function
    defaults to calling Get-OrgID -AuthToken $AuthToken to determine the organization ID. If multiple organizations
    are found, you must specify the ID explicitly.

    .EXAMPLE
    # Remove Spaces integration by specifying an organization ID explicitly
    PS> Remove-MerakiOrganizationSpacesIntegration -AuthToken "0123456789abcdef0123456789abcdef01234567" -OrganizationID "123456"

    .NOTES
    - Requires network access to api.meraki.com and a valid Meraki API key.
    - This command issues a POST to: https://api.meraki.com/api/v1/organizations/{organizationId}/spaces/integration/remove
    - The function surfaces REST exceptions; use try/catch when calling this cmdlet if you need custom error handling.
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
                "content-type" = "application/json; charset=utf-8"
            }

            $url = "https://api.meraki.com/api/v1/organizations/$OrganizationId/spaces/integration/remove"
            
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}