function Get-MerakiOrganizationAdaptivePolicyOverview {
    <#
    .SYNOPSIS
    Retrieves an overview of adaptive policy settings in the Meraki dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationAdaptivePolicyOverview function retrieves an overview of adaptive policy settings in the Meraki dashboard using the Meraki Dashboard API. You must provide an API key. You can optionally provide the ID of the organization that the overview belongs to.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER OrgID
    The ID of the organization that the overview belongs to. If not provided, the ID of the first organization returned by Get-MerakiOrganizations will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdaptivePolicyOverview -AuthToken "your_api_key"

    Retrieves an overview of adaptive policy settings in the organization.

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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/adaptivePolicy/overview" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
            return $response
        } catch {
            Write-Error $_
        }
    }
}
