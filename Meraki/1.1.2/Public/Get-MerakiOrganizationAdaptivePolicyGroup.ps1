function Get-MerakiOrganizationAdaptivePolicyGroup {
    <#
    .SYNOPSIS
    Retrieves information about a specific adaptive policy group in the Meraki dashboard.

    .DESCRIPTION
    The Get-MerakiOrganizationAdaptivePolicyGroup function retrieves information about a specific adaptive policy group in the Meraki dashboard using the Meraki Dashboard API. You must provide an API key and the ID of the group. You can optionally provide the ID of the organization that the group belongs to.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER GroupID
    The ID of the adaptive policy group.

    .PARAMETER OrgID
    The ID of the organization that the group belongs to. If not provided, the ID of the first organization returned by Get-MerakiOrganizations will be used.

    .EXAMPLE
    PS C:\> Get-MerakiOrganizationAdaptivePolicyGroup -AuthToken "your_api_key" -GroupID "1234"

    Retrieves information about the adaptive policy group with ID "1234".

    .NOTES
    For more information on the Meraki Dashboard API, see https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$GroupID,
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
            $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/organizations/$OrganizationID/adaptivePolicy/groups/$GroupID" -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
            return $response
        } catch {
        Write-Debug $_
        Throw $_
    }
    }
}
