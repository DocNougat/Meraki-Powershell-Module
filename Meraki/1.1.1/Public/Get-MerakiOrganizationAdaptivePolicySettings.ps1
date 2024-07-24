function Get-MerakiOrganizationAdaptivePolicySettings {
    <#
    .SYNOPSIS
    Retrieves adaptive policy settings for an organization in the Meraki dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationAdaptivePolicySettings function retrieves adaptive policy settings for an organization in the Meraki dashboard using the Meraki Dashboard API. You must provide an API key. You can optionally provide the ID of the organization whose settings you want to retrieve.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER OrgID
    The ID of the organization whose adaptive policy settings you want to retrieve. If not provided, the ID of the first organization returned by Get-MerakiOrganizations will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdaptivePolicySettings -AuthToken "your_api_key"

    Retrieves adaptive policy settings for the organization.

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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/adaptivePolicy/settings" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
