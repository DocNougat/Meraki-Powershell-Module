function Get-MerakiOrganizationSpacesIntegrateStatus {
    <#
    .SYNOPSIS
    Retrieves the integration status for Spaces within a Meraki organization.

    .DESCRIPTION
    Get-MerakiOrganizationSpacesIntegrateStatus queries the Meraki Dashboard API to obtain the current integration status for the Spaces product in a specified organization. If OrganizationID is not provided, the function will attempt to resolve it via Get-OrgID -AuthToken <token>. If multiple organizations are found, the function returns a sentinel string instructing the caller to specify an organization ID.

    .PARAMETER AuthToken
    The Meraki API key (X-Cisco-Meraki-API-Key). This parameter is mandatory and is used to authenticate requests against the Meraki Dashboard API.

    .PARAMETER OrganizationID
    The Meraki organization identifier (string). If omitted, the function will call Get-OrgID -AuthToken $AuthToken to determine the organization ID. If Get-OrgID returns the text "Multiple organizations found. Please specify an organization ID.", that text will be returned directly by this function.

    .EXAMPLE
    # Call using an explicit organization ID
    Get-MerakiOrganizationSpacesIntegrateStatus -AuthToken 'ABC123' -OrganizationID '123456'

    .EXAMPLE
    # Call and let the function resolve the organization ID automatically
    Get-MerakiOrganizationSpacesIntegrateStatus -AuthToken 'ABC123'

    .OUTPUTS
    System.Object
    Returns the deserialized JSON response from the Meraki API (typically a PSCustomObject or array representing the Spaces integration status). In the case where multiple organizations are detected by the resolver, a string "Multiple organizations found. Please specify an organization ID." is returned. On failure, the cmdlet will throw the underlying exception.

    .NOTES
    - Requires network access to api.meraki.com and a valid Meraki API key with permissions to read organization-level Spaces integration settings.
    - Uses the endpoint: GET /organizations/{organizationId}/spaces/integrate/status
    - The function sets the User-Agent header to "MerakiPowerShellModule/1.1.3 DocNougat".
    - HTTP errors and other exceptions from Invoke-RestMethod are thrown; debug information is written when the call fails.

    .RELATED
    Get-OrgID
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
                'X-Cisco-Meraki-API-Key' = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/spaces/integrate/status" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }
}
