function Get-MerakiOrganizationAdaptivePolicies {
    <#
    .SYNOPSIS
    Retrieves the adaptive policies for an organization in the Meraki dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationAdaptivePolicies function retrieves the adaptive policies for an organization in the Meraki dashboard using the Meraki Dashboard API. You must provide an API key. You can optionally provide the ID of the organization to retrieve adaptive policies for.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER OrgID
    The ID of the organization to retrieve adaptive policies for. If not provided, the ID of the first organization returned by Get-MerakiOrganizations will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdaptivePolicies -AuthToken "your_api_key"

    Retrieves the adaptive policies for the first organization returned by Get-MerakiOrganizations.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$false)]
        [string]$OrganizationID = (Get-OrgID -AuthToken $AuthToken)
    )
    If($OrganizationID -eq "Multiple organizations found. Please specify an organization ID.") {
        Return "Multiple organizations found. Please specify an organization ID."
    } else {
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
            }
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/adaptivePolicy/policies" -Header $header
            return $response
        } catch {
            Write-Error $_
        }
    }
}
