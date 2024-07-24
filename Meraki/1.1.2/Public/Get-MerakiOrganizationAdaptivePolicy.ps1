function Get-MerakiOrganizationAdaptivePolicy {
    <#
    .SYNOPSIS
    Retrieves an adaptive policy for an organization in the Meraki dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationAdaptivePolicy function retrieves an adaptive policy for an organization in the Meraki dashboard using the Meraki Dashboard API. You must provide an API key and the ID of the adaptive policy. You can optionally provide the ID of the organization that the adaptive policy belongs to.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER PolicyID
    The ID of the adaptive policy to retrieve.

    .PARAMETER OrgID
    The ID of the organization that the adaptive policy belongs to. If not provided, the ID of the first organization returned by Get-MerakiOrganizations will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdaptivePolicy -AuthToken "your_api_key" -PolicyID "your_policy_id"

    Retrieves the specified adaptive policy in the first organization returned by Get-MerakiOrganizations.

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$PolicyID,
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/adaptivePolicy/policies/$PolicyID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        } 
        catch {
            Write-Debug $_
            Throw $_
    }
    }
}
